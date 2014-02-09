require "mechanize"

class Google_login
	attr_accessor :email, :password, :agent

	def initionalize(email = nil, password=nil)
		@agent = Mechanize.new
		
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

		puts "\n\nid_keys: "
		pp id_keys
		puts "\n"

		new_hash = Hash.new
		id_keys.each do |key|
			tempt = data["contacts"][key]
			
			if tempt.has_key?("phoneNumber")
				future_key = tempt["phoneNumber"]
				tempt2 = Hash.new
				
				#puts "\n\n\nDO YOU HAVE A KEY CALLED phoneNumber?!\n\n\n"

			else
				#puts "\n\n\nWTF?!\n\n\n"
				next

			end

			list = ["name", "phoneTypeName", "displayNumber"]
			list.each {|term| tempt2[term] = tempt[term]}
			
			#5.times {pp tempt2}
			
			new_hash[future_key] = tempt2
		end
	new_hash
	end
			

	def messages_json()
		data = @agent.get(" http://google.com/voice/request/messages")
		data = JSON.parse(data.body)
		data
	end 
end

test = Google_login.new
test.initionalize
test.login
data = test.contacts_hash
pp data




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

