require "mechanize"

class Google_login
	attr_accessor :email, :password, :agent, :contacts, :messages

	def initionalize(email = nil, password=nil)
		@agent = Mechanize.new
		@contacts = nil
		@messages = []
		
		#print "Email: "
		@email = email

		#print "Password: "
		@password = password
	end

	def login() 
		login_page = @agent.get("https://www.google.com/accounts/ServiceLogin?service=grandcentral")
		login_page.forms.first.field_with(:name=> "Email").value = @email
		login_page.forms.first.field_with(:name=> "Passwd").value = @password
		agent.submit(login_page.forms.first)
	end

	def contacts_json()
		data = @agent.get("http://google.com/voice/request/user")
		data = JSON.parse(data.body)
		data
	end

	def contacts_hash()
		data = contacts_json()
		
		id_keys = []
		data["contacts"].each {|key, value| id_keys << key}

		new_hash = Hash.new
		id_keys.each do |key|
			tempt = data["contacts"][key]
			
			if tempt.has_key?("phoneNumber")
				future_key = tempt["phoneNumber"]
				tempt2 = Hash.new
			else
				next
			end

			list = ["name", "phoneTypeName", "displayNumber"]
			list.each {|term| tempt2[term] = tempt[term]}
			
			new_hash[future_key] = tempt2
		end
	@contacts = new_hash
	end

	def messages_hash()
		data = messages_json()

		id_keys = []

		data["messageList"].each do |hope|		

			#5.times {puts hope.class, "\n\n\n"}

			list = ["id", "type", "phoneNumber", "startTime", "displayStartDateTime",
								 "displayStartTime", "messageText", "children"]
			
			tempt = Hash.new

			list.each do |key|
				tempt[key] = hope[key]
			end
			puts tempt, "\n\n"	
			@messages << tempt

			#puts "messages:\n", messages, "\n\n"
			@messages.sort! {|a,b| b["startTime"] <=> a["startTime"] }
			#@messages = Hash[@messages.to_a.reverse]
			@messages
		end
	end
			

	def messages_json()
		data = @agent.get(" http://google.com/voice/request/messages")
		data = JSON.parse(data.body)
		data
	end

	def write_to_file

		result = ""

		@messages.each do |logs, value|
			
			list = ["phoneNumber", "type", "diplayStartDateTime", "messageText"]
		
			if @contacts.has_key?(list[0])
				name = @contacts[list[0]]
			else
				name = logs[list[0]]
			end
	
			type = type_check(logs[list[1]])

			time = logs[list[2]]
			text = logs[list[3]]
			
			result += ("Person: %s\nType: %s\nTime: %s\nText: %s" % [name, type.to_s, time, text])
			
			count = 0
			logs["children"].each do |x|

				tempt = x

				result += ("\n\nContinued Communication:\n")
				
				type = type_check(["type"])
				begin				
					time = tempt["displayStartDateTime"]
				rescue
					time = ""
				end

				result += ("Time: %s\n" % [time])

				begin
					text = tempt["message"]
				rescue
					text = ""
				end

				result += ("Text: %s\n" % [text])
				count += 1

				puts "#{result}\n"
			end
		end
		File.open("test2.txt", "w+") do |file|
			file.puts result
			break
		end
	end

	def type_check(test)
		if test == 2
			type = "recieved call"
		elsif test == 10
			type = "sent sms"
		elsif test == 11
			type = "recieved call"
		else
			type = "Unknown"
		end
		type
	end
end


=begin
test = Google_login.new
test.initionalize
test.login
test.contacts_hash
puts "test.contacts"
pp test.contacts


#test = Google_login.new
#test.initionalize
#test.login
test.messages_hash
puts "test.messages"
pp test.messages

test.messages.each {|x,y| puts x.class}
test.write_to_file
=end
