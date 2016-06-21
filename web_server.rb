#A simple server
require 'socket'
require 'json'

server = TCPServer.open(2000)
loop {  #server runs forever
	client = server.accept

	#loops until whole header is grabbed
	header = ""
	while line = client.gets
		header << line
		break if header =~ /\r\n\r\n$/
	end

	#parses out method and path from status line
	method = header.split[0]
	path = header.split[1][1..-1]

	if method == "GET" && File.exist?(path)
		response_body = (File.open(path, 'r')).read
    	response_head = "HTTP/1.0 200 OK\nContent-Length: #{response_body.length}\r\n\r\n"
	else
    	response_head = ("HTTP/1.0 404 Not Found\r\n\r\n")
    	response_body = ("Sorry, file not found.")
	end

	if method == "POST" && File.exist?(path)
		body = ""
		while line = client.gets
			body << line
			break if body =~ /\r\n\r\n$/
		end
	

	params = {}
	params = JSON.parse(body)
	entries = ""
	params["viking"].each do |key, value|
		entries += "<li>#{key}: #{value}</li>\n"
	end

	file = File.open(path)
	response_body = file.read.gsub("<%= yield %>", entries)
	response_head = "HTTP/1.0 200 OK\nContent-Length: #{body.length}"
	end

	client.puts(response_head)
  	client.puts(response_body)
	client.close
}