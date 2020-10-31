note
	description: "Summary description for {BAD_BIRTHDAY_VIOLATING_DAY_SET}."
	author: "nevess99"
	date: "$Date$"
	revision: "$Revision$"

class
	BAD_BIRTHDAY_VIOLATING_DAY_SET

inherit
	BIRTHDAY
		redefine
			make
		end

create
	make

feature --redefine command(make).
		--rest of classes are inherited as is

	make(m: INTEGER; d: INTEGER)
		do
			--wrong implementation
			month := m
			day := m	--this line should trigger a postcondition violation with tag 'day_set'
		--do not write any postcondition here
		--all postcondition from BIRTHDAY will be inherited.
		end

end
