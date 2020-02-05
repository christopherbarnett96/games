

puts "Enter your name\n "
user_name = gets.chomp.capitalize

puts "\n#{user_name}. Welcome to the mystery of the lost Cigarette.\nYou are back in first year, no worries and no responsibilities, you're a dirty fresher and addicted to nicotine.\nGeorge is giving out free Papers so go into his room and get as many as you need, you'll have to buy Tobacco off him though\nYour mission: Smoke a Cigarette\nType \"help\" for list of commands"

inventory = [""]
move_counter = 0

 if user_name.downcase == "topher"
   inventory.push("Tobacco")
   inventory.push("Filters")
   inventory.push("Paper")
   inventory.push("A Fiver")
 end

help = "Commands:\nl - left\nr - right\nf - forward\nb - back\ni - inspect\nt - talk\ns - search\ninv - inventory\ngrind\nroll\ntrade\nsmoke\nhelp\nexit"


class Location
        attr_accessor :name, :description, :dialogue, :left, :right, :back, :forward, :item, :required_key
        def initialize(params)
                @name = params[:name]
                @description = params[:description]
                @dialogue = params[:dialogue]
        end
        def left=(loc)
                @left = loc
                @left.right = self unless @left.right
        end
        def right=(loc)
                @right = loc
                @right.left = self unless @right.left
        end
        def back=(loc)
                @back = loc
                @back.forward = self unless @back.forward
        end
        def forward=(loc)
                @forward = loc
                @forward.back = self unless @forward.back
        end
end

hallway = Location.new( :name => "in The Hallway", :description => "Kitchen on left\nGeorge's Room on right" )
hallway.required_key = ""

hallway.left = Location.new( :name => "in The Kitchen", :description => "You are by the fridge" )

hallway.right = Location.new( :name => "in George's Room", :description => "Smells kinda funny in here, lots of cash lying around\ntype 'trade' to pick up some of that sweet Tobacco" )
hallway.right.forward = Location.new( :name => "in George's Bathroom", :description => "Someone has clearly been smoking in here, ash tray by the sink. Why doesn't he just throw the butts in the toilet?")

hallway.forward = Location.new( :name => "in The Hallway", :description => "Owen's Room on left\nAdam's Room on right" )
hallway.forward.required_key = ""

hallway.forward.left = Location.new( :name => "in Owen's Room", :description => "His window seems to be open, must've somehow unlocked the safety hinge" )
hallway.forward.left.forward = Location.new( :name => "in Owen's Bathroom", :description => "Extractor fan doesnt seem to be working properly")
hallway.forward.left.left = Location.new( :name => "on The Roof", :description => "Really sketchy here, super windy too, better go back")
hallway.forward.left.left.forward = Location.new( :name => "on The Roof")
hallway.forward.left.left.forward.required_key = "Owen's key"

hallway.forward.right = Location.new( :name => "in Adam's Room", :description => "Normal room, seems to play a lot of Xbox" )
hallway.forward.right.forward = Location.new( :name => "in Adam's Bathroom", :description => "Extractor fan doesn't seem to be working properly")

hallway.forward.forward = Location.new( :name => "in The Hallway", :description => "Cam's Room on left\nAngus' Room on right" )
hallway.forward.forward.required_key = ""

hallway.forward.forward.left = Location.new( :name => "in Cam's Room", :description => "Likes his shoes, better leave before he notices" )

hallway.forward.forward.right = Location.new( :name => "in Angus' Room", :description => "Hockey kit is everywhere, Adam is snooping around", :dialogue => "\"#{user_name}! I've been looking for you! Have you seen my lighter?\"" )
hallway.forward.forward.right.forward = Location.new( :name => "in Angus' Bathroom", :description => "Extractor fan doesn't seem to be working properly")

hallway.forward.forward.forward = Location.new( :name => "in The Hallway", :description => "Your room on left")
hallway.forward.forward.forward.required_key = ""
hallway.forward.forward.forward.left = Location.new( :name => "in Your Room", :description => "There's a Fiver on the desk")
hallway.forward.forward.forward.left.required_key = ""
hallway.forward.forward.forward.left.forward = Location.new( :name => "in Your Bathroom", :description => "Extractor fan doesn't seem to be working properly")
hallway.forward.forward.forward.left.forward.required_key = ""

user_room = hallway.forward.forward.forward.left
user_room.item = "A Fiver"

angus_room = hallway.forward.forward.right
angus_room.required_key = "Angus' key"
angus_room.item = "Adam's key"
angus_bathroom = hallway.forward.forward.right.forward
angus_bathroom.required_key = "Angus' key"

adam_room = hallway.forward.right
adam_room.required_key = "Adam's key"
adam_bathroom = hallway.forward.right.forward
adam_bathroom.required_key = "Adam's key"
adam_bathroom.item = "Owen's key"

cam_room = hallway.forward.forward.left
cam_room.required_key = "Cam's key"

owen_room = hallway.forward.left
owen_room.required_key = "Owen's key"
owen_room.item = "Tobacco"
owen_bathroom = hallway.forward.left.forward
owen_bathroom.required_key = "Owen's key"
the_roof = hallway.forward.left.left
the_roof.required_key = "Owen's key"

george_room = hallway.right
george_room.required_key = "George's key"
george_room.item = "Paper"
george_bathroom = hallway.right.forward
george_bathroom.required_key = "George's key"
george_bathroom.item = "Angus' key"

kitchen = hallway.left
kitchen.required_key = ""

kitchen.forward = Location.new( :name => "in The Kitchen", :description => "Next to a cooker, looks like this place hasnt been cleaned in weeks\nOwen is eating", :dialogue => "\"Was literally just about to smoke but my door's locked and I've lost my key, got a lighter though lmao\"" )
kitchen.forward.required_key = ""
kitchen.forward.item = "Lighter"

kitchen.forward.forward = Location.new( :name => "in The Kitchen" , :description => "You see a sofa, Cam is sat on it", :dialogue => "\"Can't believe I've lost like 7 keys in this sofa, pretty sure I lost a Fiver in here somewhere as well\"")
kitchen.forward.forward.required_key = ""
kitchen.forward.forward.item = "George's key"

current_room = hallway
catch :end_of_game do
        loop do
                puts "\nYou are #{current_room.name}.\n "
                instruction = gets
                next_room = case instruction.chomp
                        when "f"
                                current_room.forward
                        when "b"
                                current_room.back
                        when "l"
                                current_room.left
                        when "r"
                                current_room.right
                        when "i"
                                puts "\n#{current_room.description}"
                                redo
                        when "t"
                              if current_room.dialogue == nil
                                puts "\nYou are talking to yourself"
                                redo
                              else
                                puts "\n#{current_room.dialogue}"
                                redo
                              end
                        when "s"
                              if current_room.item == nil || current_room.item == ""
                                puts "\nNothing in here"
                                redo
                              elsif current_room.item == "Cigarette" || current_room.item == "Match"
                                inventory.push(current_room.item.clone)
                                puts "\nYou found #{current_room.item}!"
                                inventory.delete(nil)
                                current_room.item.clear
                                redo
                              else
                                inventory.push(current_room.item.clone)
                                puts "\nYou found #{current_room.item}!"
                                inventory.delete(nil)
                                redo
                              end
                        when "roll"
                                if inventory.include?("Paper") && inventory.include?("Tobacco") && inventory.include?("Filters")
                                  inventory.delete("Paper")
                                  inventory.delete("Tobacco")
                                  inventory.push("Cigarette")
                                  puts "\nYou rolled a Cigarette"
                                  redo
                                else puts "\nNeed Paper, Tobacco AND Filters"
                                  redo
                                end
                        when "trade"
                                if current_room == george_room && inventory.include?("A Fiver")
                                  inventory.delete("A Fiver")
                                  inventory.push("Tobacco")
                                  puts "\nYou picked up a pouch of Tobacco"
                                  redo
                                elsif current_room == angus_room && inventory.include?("Lighter")
                                  inventory.delete("Lighter")
                                  inventory.push("Filters")
                                  puts "\nAdam gave you Filters!"
                                  redo
                                else puts "\nNothing to trade"
                                  redo
                                end
                        when "inv"
                                puts inventory
                                redo
                        when "exit"
                                throw :end_of_game
                        when "smoke"
                              if current_room != george_bathroom && inventory.include?("Cigarette") && inventory.include?("Lighter")
                                puts "\nYou can't smoke that here. Security has taken your ass downtown and taken all your shit"
                                inventory.clear
                                inventory.push("")
                                current_room = hallway
                                redo
                              elsif inventory.include?("Cigarette") && inventory.include?("Lighter")
                                puts "\nWell done ranger, finally got that sweet smoke"
                                break
                              else
                                puts "\nNeed to have Cigarette AND Lighter"
                                redo
                              end
                        when "help"
                                puts "\n#{help}"
                             redo
                        else redo

                end
                  if inventory.include?(nil)
                          inventory.delete(nil)
                  end
                  if next_room == hallway.forward.left.left.forward
                    puts "\nYou died"
                    inventory.clear
                    inventory.push("")
                    current_room = hallway
                    redo
                  end
                  if next_room == nil
                          puts "\nYou cant go that way!"
                          redo
                  end
                  if !inventory.include?(next_room.required_key)
                          puts "\nThat door is locked"
                          next_room = current_room
                  end
                  if next_room
                          current_room = next_room
                  end

        end
end
puts "\nUntil next time!"
