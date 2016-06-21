require 'socket'
require 'json'

host = 'localhost'
port = 2000
path = "/index.html"

puts "What time of request would you like to send? 'GET' or 'POST'"
request = gets.upcase.chomp

until request == "GET" || request == "POST"
	puts "Please select 'GET' or 'POST'"
	request = gets.upcase.chomp
end

if request == "GET"
	request = "GET #{path} HTTP/1.0\r\n\r\n"
elsif request == "POST"
	path = "/thanks.html"
	information = {:viking => {}}
	puts "Please enter your name..."
	name = gets.chomp
	information[:viking][:name] = name
	puts "Thank you. Now please enter your email..."
	email = gets.chomp
	information[:viking][:email] = email


request = <<POST_REQUEST
	POST #{path} HTTP/1.0
	From: #{email}
	Content-Type: application/json
	Content-Length: #{information.to_json.length}
	\r\n\r\n#{information.to_json}\r\n\r\n
POST_REQUEST
end


#request = "GET #{path} HTTP/1.0\r\n\r\n"

socket = TCPSocket.open(host, port)
socket.print(request)
response = socket.read
headers,body = response.split("\r\n\r\n", 2)
puts headers
puts body
socket.close