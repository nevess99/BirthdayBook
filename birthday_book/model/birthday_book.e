note
	description: "Summary description for {BIRTHDAY_BOOK}."
	author: "nevess99"
	date: "$Date$"
	revision: "$Revision$"

class
	BIRTHDAY_BOOK

create
	make_empty

feature	--Attributes
	names: ARRAY[STRING]
	birthdays: LIST[BIRTHDAY]	--program from the interface, not from the implementation

	count: INTEGER
		--number of stored name-birthday records
feature	--Queries

	get_birthday(name: STRING): BIRTHDAY	--given a name, return birthday
		require
			existing_name:
				names.has (name)
		local
			i: INTEGER
		do
			--because the return type BIRTHDAY is attached, we must explicitly initialize Result
			create Result.make(10, 15)	--just to initialize Result
		from
			i := 1
		until
			i > names.count
		loop
			if names[i] ~ name then
				Result := birthdays[i]
			end
			i := i + 1
		end
		ensure
			correct_result:
				Result ~ birthdays[index_of_name(name)]
		end

	get_detachable_birthday(name: STRING):detachable BIRTHDAY	--detachable, return value may be void
		--return the corresponding birthday, if the 'name' exists
		--Otherwise return void
		local
			i: INTEGER
		do
--			from
--				i := 1
--			until
--				i > names.count
--			loop
--				if names[i] ~ name then
--					--if this condition re-assignmentnever occurs,
--					--Result will continue storing void
--					--this is acceptable because the return type is 'detachable BIRTHDAY'
--					Result := birthdays[i]
--				end
--				i := i + 1
--			end
			i := index_of_name(name)
			if i > 0 then
				Result := birthdays[i]
			end
		ensure
			case_of_non_void_result:
--				Result /= void implies Result ~ birthdays[index_of_name(name)]
				attached Result implies Result ~ birthdays[index_of_name(name)]
			case_of_void_result:
--				Result = void implies not names.has (name)
				not attached Result implies not names.has (name)

		end

	celebrate(today: BIRTHDAY): like names	--anchor type: retunr type should be the same as 'names'
		--Given the date of 'today', returns a collection (anchoring type of 'names') of names
		require	--make sure birthday date exists in bb
			existing_birthday:
				birthdays.has (today)

		local
			i: INTEGER
		do
			create Result.make_empty
			Result.compare_objects
		from
			i := 1
		until
			i > names.count
		loop
			if today ~ (get_birthday(names[i])) then
				Result.force (names[i], Result.count + 1 )
			end
			i := i + 1
		end

		ensure
			lower_of_result:
				Result.lower = 1
			every_name_in_result_is_an_existing_name:
				across
					Result is l_n
				all
					names.has (l_n)
				end
			every_name_in_result_has_birthday_today:
				across
					Result is l_n
				all
					today.is_equal (get_birthday(l_n))
				end
			Result.count <= count
		end

feature--Auxiliary Queries
	index_of_name(name : STRING): INTEGER
		--Returns the index of 'name' in 'names' if it exists
		--Otherwise it returns 0
		local
			i: INTEGER
		do
			i := 1	--assumung names.lower = 1
			Result := 0
			across
				names is l_n
			loop
				if l_n ~ name then
					Result := i
				end
				i := i + 1
			end
		end

feature	--Command
	make_empty	--used as contuctor
		--create an empty birthday book.
	do
		create names.make_empty	--Equivalent to: create {ARRAY[STRING]} names.make_empty
		names.compare_objects
		create {LINKED_LIST[BIRTHDAY]} birthdays.make
		birthdays.compare_objects
	end

	add(name: STRING; birthday: BIRTHDAY)
		-- Adds a new record with 'name' and 'birthday'
		require
			non_existing_name:
--				not names.has (name)
--				not(across names is l_n some l_n ~ name end)
				across names is l_n all l_n /~name end	--all are equivalent to each other
		do
			names.force (name, names.count + 1)
			birthdays.extend (birthday)
			count := count + 1
		ensure
			count_incremented:
				count = old count + 1
			name_added_to_end:
				names[count] ~ name
			birthday_added_to_end:
				birthdays[count] ~ birthday
		end


invariant
	consistent_counts:
		Current.count = names.count and count = birthdays.count
	no_duplicate_names:
		across 1|..| names.count is l_i all
		across 1|..| names.count is l_j all
			l_i /= l_j implies names[l_i] /~ names[l_j]
		end

		end
end
