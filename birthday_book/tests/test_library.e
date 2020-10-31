	note
	description: "Summary description for {TEST_LIBRARY}."
	author: "nevess99"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_LIBRARY

inherit
	ES_TEST

create
	make

feature -- Constructor
	make
		do
			add_boolean_case (agent test_arrays)
			add_boolean_case (agent test_lists)
			add_boolean_case (agent test_across_loops)
			add_boolean_case (agent test_quantifications)
		end

feature --boolean tests
	test_arrays: BOOLEAN
		local
			s1, s2: ARRAY[STRING]
			i: INTEGER
		do
			comment ("test_arrays: test basic operations of arrays")
			create s1.make_empty
			Result :=
				-- size of array : upper - lower + 1
				s1.lower = 1 and s1.upper = 0 and s1.count = 0 and s1.is_empty
				and
				not s1.valid_index (0) and not s1.valid_index (1)
				check Result end

				s1.force ("Alan", s1.count + 1)
				s1.force ("Mark", s1.count + 1)
				s1.force ("Tom", s1.count + 1)
				Result :=
					s1.lower = 1 and s1.upper = 3 and s1.count = 3 and not s1.is_empty
					and
					not s1.valid_index (0) and s1.valid_index (1) and s1.valid_index (2) and s1.valid_index (3)
					and
					s1[1] ~ "Alan" and s1.item (2) ~ "Mark" and s1[3] ~ "Tom"
				check Result end

				Result :=
					s1.object_comparison = false
					and
					s1.has ("Alan") = false
					and
					s1.occurrences ("Alan") = 0
				check Result end

				s1.compare_objects
				Result :=
					s1.object_comparison = true
					and
					s1.has ("Alan") = true
					and
					s1.occurrences ("Alan") = 1
				check Result end

				create s2.make_empty

				from
					i := 1 --assuming that s1.lower is 1, i is assigned to 1
				until
					i > s1.count  -- exit condition
				loop
					s2.force (s1[i], s2.count + 1)
					i := i + 1
				end

				Result :=
					s2.lower = 1 and s2.upper = 3 and s2.count = 3 and not s2.is_empty
					and
					not s2.valid_index (0) and s2.valid_index (1) and s2.valid_index (2) and s2.valid_index (3)
					and
					s2[1] ~ "Alan" and s2.item (2) ~ "Mark" and s2[3] ~ "Tom"
				check Result end

				Result := s1 /= s2

				check Result end

				Result := s1 /~ s2 -- s1.object_comparison is true, but s2.object_comparism is false
				check Result end

				s2.compare_objects
				Result := s1 ~ s2
				check Result end

				s2[2] := "Jim"
				s2.put("Jeremy", 3)	--similar to force but you are changing exisitng position
				Result :=
					s2.count = 3 and s2[1] ~ "Alan" and s2[2] ~ "Jim" and s2[3] ~ "Jeremy"
		end

	test_lists: BOOLEAN
		local
			s1, s2, s3: LINKED_LIST[STRING]
			i: INTEGER
		do
			comment ("test_arrays: test basic operations of arrays")
			create s1.make
			Result :=
				s1.count = 0 and s1.is_empty
				and
				not s1.valid_index (0) and not s1.valid_index (1)
				check Result end

				s1.extend ("Alan")
				s1.extend ("Mark")
				s1.extend ("Tom")
				Result :=
					s1.count = 3 and not s1.is_empty
					and
					not s1.valid_index (0) and s1.valid_index (1) and s1.valid_index (2) and s1.valid_index (3)
					and
					s1[1] ~ "Alan" and s1[2] ~ "Mark" and s1[3] ~ "Tom"
				check Result end

				--by default object_comparison is false
				Result :=
					s1.object_comparison = false
					and
					s1.has ("Alan") = false
					and
					s1.occurrences ("Alan") = 0
				check Result end

				s1.compare_objects
				Result :=
					s1.object_comparison = true
					and
					s1.has ("Alan") = true
					and
					s1.occurrences ("Alan") = 1
				check Result end

				create s2.make

				from
					i := 1 --assuming that s1.lower is 1, i is assigned to 1
				until
					i > s1.count  -- exit condition
				loop
					s2.extend (s1[i])
					i := i + 1
				end

				Result :=
					s2.count = 3 and not s2.is_empty
					and
					not s2.valid_index (0) and s2.valid_index (1) and s2.valid_index (2) and s2.valid_index (3)
					and
					s2[1] ~ "Alan" and s2[2] ~ "Mark" and s2[3] ~ "Tom"
				check Result end

				Result := s1 /= s2

				check Result end

				Result := s1 /~ s2 -- s1.object_comparison is true, but s2.object_comparism is false
				check Result end

				s2.compare_objects
				Result := s1 ~ s2
				check Result end

				create s3.make
				from
					s1.start --move the cursor to the first position
				until
					s1.after --exit when the cursor position is beyond the list
				loop
					s3.extend (s1.item) --extend s3 by where s1's cursor is pointing to
					s1.forth

				end

				Result :=
					s3.count = 3 and not s3.is_empty
					and
					not s3.valid_index (0) and s3.valid_index (1) and s3.valid_index (2) and s3.valid_index (3)
					and
					s3[1] ~ "Alan" and s3[2] ~ "Mark" and s3[3] ~ "Tom"
				check Result end


				Result :=
					s1 /= s3 and s2 /= s3
					and
					s1 /~ s3 and s2 /~ s3 	-- because s3.object_comparison is false by default
				check Result end

				s3.compare_objects
				Result :=
					s1 /= s3 and s2 /= s3
					and
					s1 ~ s3 and s2 ~ s3 	-- because s3.object_comparison is now true
				check Result end

				s2[2] := "Jim"
				Result :=
					s2.count = 3 and s2[1] ~ "Alan" and s2[2] ~ "Jim" and s2[3] ~ "Tom"

		end

	test_across_loops : BOOLEAN
		local
			a: ARRAY[STRING]
			list1, list2, list3: LINKED_LIST[STRING]
		do
			comment ("test_across_loops: use of across as loop instuctions")
			a := <<"Alan", "Mark", "Tom">>
			create list1.make
			across
				 1|..| a.count as l_i	--l_1 denotes a cursor pointing to an (iterable collectioin of integer) integer
			loop
				list1.extend (a[l_i.item])
			end
			Result := list1.count = 3 and list1[1] ~ "Alan" and list1[2] ~ "Mark" and list1[3] ~ "Tom"
			check Result end

			create list2.make
			across
				 1|..| a.count is l_i	--l_1 denotes an integer(memeber of the interval)
			loop
				list2.extend (a[l_i])
			end
			Result := list2.count = 3 and list2[1] ~ "Alan" and list2[2] ~ "Mark" and list2[3] ~ "Tom"
			check Result end

			create list3.make
			across
				 a is l_name	-- 'a' being an array is iterable; 'l_name' denoted a member string of the array
			loop
				list3.extend (l_name)
			end
			Result := list3.count = 3 and list3[1] ~ "Alan" and list3[2] ~ "Mark" and list3[3] ~ "Tom"
		end

	test_quantifications: BOOLEAN
		local
			a: ARRAY[STRING]
		do
			comment ("test_quantifications: use of across as boolean expressions")
			Result :=
				not (across
					 1|..| 10 is l_i	--denoted a member of the interval from 1,..,10
				all
					l_i > 5
				end) 	--expected to be false, so we negate it

				and

				across
					 1|..| 10 is l_i	--denoted a member of the interval from 1,..,10	
				some
					l_i > 5
				end
			check Result end

			a := <<"Yuna", "Suyeon", "Heeyeon">>
			Result :=	--across over valid index set of array (integer by integer)
				not (across 1|..| a.count is l_i all a[l_i].count > 4 end)	--checking length of every string
				and
				across 1|..| a.count is l_i some a[l_i].count > 4 end
			check Result end

			Result :=	--across over members of array a(string by string)
				not (across a is l_s all l_s.count > 4 end)	--across array 'a' is local string.
				and
				across a is l_s some l_s.count > 4 end
			check Result end
			Result :=
				across 1|..| (a.count - 1) is l_index all a[l_index].count <= a[l_index + 1].count end
		end

end
