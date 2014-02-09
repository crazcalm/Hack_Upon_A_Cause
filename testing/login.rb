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
			@messages.sort_by! {|h| h["startTime"]}
		end
	end
			

	def messages_json()
		data = @agent.get(" http://google.com/voice/request/messages")
		data = JSON.parse(data.body)
		data
	end

	def write_to_file
		@messages.each do |logs, value|

			#3.times {puts logs, "\n"}
			
			list = ["phoneNumber", "type", "diplayStartDateTime", "messageText"]
		
			if @contacts.has_key?(list[0])
				name = @contacts[list[0]]
			else
				name = logs[list[0]]
			end
	
			#3.times {puts "Are you bloken?\n"}
			
			type = type_check(logs[list[1]])

			#3.times {puts "Give me a clue!!\n"}	

			time = logs[list[2]]
			text = logs[list[3]]

			#3.times {puts "Which one of you is being bad!\n"}
			
			result = ("Person: %s\nType: %s\nTime: %s\nText: %s" % [name, type.to_s, time, text])

			#3.times {puts "Please tell me it ain't so!\n"}
			
			count = 0
			logs["children"].each do |x|

				#3.times{puts "Where are you!!!\n"}

				tempt = x

				
				result += ("\n\nContinued Communication:\n")
				
				type = type_check(["type"])

				#if type.type == String
				#	type
				#else
				#	type = " "
				#end
	
				#3.times {puts "Found you!!!\n"}

				#result += ("Type: %s\n" % [type])

				#3.times {puts "Type broken?\n"}

				#if tempt["displayStartDateTime"].type == String
				begin				
					time = tempt["displayStartDateTime"]
				rescue
					time = ""
				end
				#else
				#	time = ""
				#end

				#3.times {puts "Time broken?\n"}

				#result += ("Time: %s\n" % [time])

				#if tempt["message"].type == String
				begin
					text = tempt["message"]
				rescue
					text = ""
				end
				#else
				#	text = ""
				#end				

				#3.times{puts "Text broken?\n"}

				result += ("Text: %s\n" % [text])
				count += 1

				#3.times {puts "WTF!!!!\n"}

				#result += ("Type: %s\nTime: %s\nText: %s" % [type, time, text])

				#3.times{puts "This is getting annoying\n"}

				puts "#{result}\n"
			end

			File.open("test2.txt", "a") do |file|
				file.puts result
			end
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
