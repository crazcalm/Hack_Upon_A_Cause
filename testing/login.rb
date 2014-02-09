require "mechanize"

class Google_login
	attr_accessor :email, :password, :agent, :contacts, :messages

	def initionalize(email = nil, password=nil)
		@agent = Mechanize.new
		@contacts = nil
		@messages = []
		
		print "Email: "
		@email = gets.chomp

		print "Password: "
		@password = gets.chomp
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

			puts "messages:\n", messages, "\n\n"
			@messages.sort_by! {|h| h["startTime"]}
		end
	end
			

	def messages_json()
		data = @agent.get(" http://google.com/voice/request/messages")
		data = JSON.parse(data.body)
		data
	end 
end

=begin
# This works!
test = Google_login.new
test.initionalize
test.login
test.contacts_hash
puts "test.contacts"
pp test.contacts
=end

test = Google_login.new
test.initionalize
test.login
test.messages_hash
puts "test.messages"
pp test.messages







=begin
def contact_hash(json)

	stack = []
	json["contacts"].each do |key_1, key_2|
		if key_2.has_key?("phoneNumber")
			new_dict = key_2["phoneNumber"]
			new_dict = Hash.new

			list = ["name", "phoneTypeName", "displayNumber"]

			list.each {|key| new_dict[key] = key_2[key]}
			
			stack << new_dict
		else
			puts "\n\nNothing to see here!\n\n"
		end
	stack
	end
end
			 
=end

