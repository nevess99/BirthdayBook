note
	description: "Summary description for {BIRTHDAY_BOOK_VIOLATING_NAME_ADDED_TO_END}."
	author: "nevess99"
	date: "$Date$"
	revision: "$Revision$"

class
	BIRTHDAY_BOOK_VIOLATING_NAME_ADDED_TO_END

inherit
	BIRTHDAY_BOOK
		redefine
			add
		end

create
	make_empty

feature	--command
	add(name: STRING; birthday: BIRTHDAY)
		-- Adds a new record with 'name' and 'birthday'
		do
			--correct version of implementation
			names.force (name, names.count + 1)
			birthdays.extend (birthday)
			count := count + 1

			--Wrong implementation
			--e.g., when after the addition, if the size of the birthday book is 2,
			--then replace the last name by the 2nd last name
			if count > 1 then
				names[count] := names[count - 1]
			end
		--postcondition is inherited from BIRTHDAY_BOOK
		end
end
