note
	description: "Summary description for {TEST_BIRTHDAY_BOOK}."
	author: "nevess99"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_BIRTHDAY_BOOK

inherit
	ES_TEST

create
	make

feature	--Add tests
	make
		do
			--boolean tests
			add_boolean_case (agent t_add)
			add_boolean_case (agent t_get)
			add_boolean_case (agent t_celebrate)
--			add_boolean_case (agent t_index_of_name)

			--violation tests
			add_violation_case_with_tag("non_existing_name", agent t_precond_add)
			add_violation_case_with_tag ("name_added_to_end", agent t_postcond_add)
		end

feature	--Boolean tests

	t_add: BOOLEAN
		local
			bb: BIRTHDAY_BOOK
			bd1, bd2, bd3: BIRTHDAY
		do
			comment ("t_add: test additions to the birthday book")
			create bb.make_empty
			Result := bb.count = 0 and bb.names.count = 0 and bb.birthdays.count = 0
			check Result end

			create bd1.make (9, 14)
			create bd2.make (3, 31)
			create bd3.make (7, 2)
			bb.add ("Alan", bd1)
			bb.add ("Mark", bd2)
			bb.add ("Tom", bd3)
			Result := bb.count = 3 and bb.names[1] ~ "Alan" and bb.birthdays[1] ~ (create{BIRTHDAY}.make (9, 14))
		end

		t_get: BOOLEAN
		local
			bb: BIRTHDAY_BOOK
			bd1, bd2, bd3: BIRTHDAY
		do
			comment ("t_get: test getting birthdays from the birthday book")
			create bb.make_empty
			Result := bb.count = 0 and bb.names.count = 0 and bb.birthdays.count = 0
			check Result end

			create bd1.make (9, 14)
			create bd2.make (3, 31)
			create bd3.make (7, 2)
			bb.add ("Alan", bd1)
			bb.add ("Mark", bd2)
			bb.add ("Tom", bd3)
			Result :=
				bb.get_birthday ("Mark").month = 3 and bb.get_birthday ("Mark").day = 31
				and
				bb.get_birthday ("Mark") ~ (create{BIRTHDAY}.make (3, 31))
			check Result end

			Result :=
				bb.get_detachable_birthday ("Mark") ~ (create{BIRTHDAY}.make (3, 31))
			check Result end

			check attached bb.get_detachable_birthday ("Mark") as mark_bd then
				Result := mark_bd.month = 3 and mark_bd.day = 31
			end
			check Result end

			check
				attached bb.get_detachable_birthday ("Alan") as alan_bd
				and
				attached bb.get_detachable_birthday ("Tom") as tom_bd
			then
				Result :=
					alan_bd.month = 9 and alan_bd.day = 14
					and
					tom_bd.month = 7 and tom_bd.day = 2
			end
			check Result end
		end

		t_celebrate: BOOLEAN
			local
				bb: BIRTHDAY_BOOK
				bd1, bd2, bd3: BIRTHDAY
--				a1, a2, a3: ARRAY[STRING]
				n_r1, n_r3, n_r2: ARRAY[STRING]
			do
				comment ("t_celebrate: test getting names given a birthday")
				create bb.make_empty
				Result := bb.count = 0 and bb.names.count = 0 and bb.birthdays.count = 0
			check Result end
			create bd1.make (9, 14)
			create bd2.make (3, 31)
			create bd3.make (7, 2)
			bb.add ("Alan", bd1)
			bb.add ("Mark", bd2)
			bb.add ("Tom", bd3)
			bb.add ("Jim", bd2)
			n_r1 := bb.celebrate (create{BIRTHDAY}.make (9, 14))
			n_r2 := bb.celebrate (bd2)
			n_r3 := bb.celebrate (bd3)

			Result := bb.count = 4 and bb.names.count = 4 and bb.birthdays.count = 4
			check Result end

--			Result :=
--				bb.celebrate (bd1) ~ bb.names[1]

			Result :=
				n_r1[1] ~ "Alan"
				and
				n_r3[1] ~ "Tom"
				and
				n_r2[1] ~ "Mark"
				and
				n_r2[2] ~ "Jim"


			check Result end


			end


feature	--Violation tests

	t_precond_add
		local
			bb: BIRTHDAY_BOOK
--			bd: BIRTHDAY
		do
			comment("t_precond_add: test the precondition of add with an existing name")
			create bb.make_empty
--			create bd.make(9, 14)
			bb.add ("Alan", create{BIRTHDAY}.make (9, 14))	--precondition not expected here because Alan does not exist in empty book
			bb.add ("Alan", create{BIRTHDAY}.make (4, 23))

		end



	t_postcond_add
		local
			bd: BIRTHDAY_BOOK_VIOLATING_NAME_ADDED_TO_END
		do
			comment("t_postcond_add: test the postcondition of add with tag name_added_to_end by wrong implementation")
			create bd.make_empty
			bd.add ("Alan", create{BIRTHDAY}.make (7, 2))	--postcondition violation not expected
			bd.add ("Mark", create{BIRTHDAY}.make(8, 15))	--the wrong implementation will replace bb.names[2] with bb.names[1]

		end

end
