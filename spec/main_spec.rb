describe 'database' do
    def run_script(commands)
        raw_output = nil
        IO.popen("./build/db test.db", "r+") do |pipe|
            commands.each do |command|
                pipe.puts command
            end
            pipe.close_write

            # Read entire output
            raw_output = pipe.gets(nil)
        end
        raw_output.split("\n")
    end

    def reset_db()
        if File.exist?("test.db")
            begin
                File.delete("test.db")
                return 0
                rescue StandardError
                    return 1
            end
        end

        # If file doesn't exist consider it a success
        return 0
    end

    it 'inserts and retrieves a row' do
        result = run_script([
            "insert 1 user person@example.com",
            "select",
            ".exit",
        ])
        expect(result).to match_array([
            "db > Executed.",
            "db > (1, user, person@example.com)",
            "Executed.",
            "db > ",
        ])

        # Reset the database
        reset_result = reset_db()
        expect(reset_result).to eq(0), "Failed to reset the database. Delete operation failed."
    end

    it 'prints error messsage when table is full' do
        script = (1..1401).map do |i|
            "insert #{i} user#{i} person#{i}@example.com"
        end
        script << ".exit"
        result = run_script(script)
        expect(result[-2]).to eq('db > Error: Table full.')
        
        # Reset the database
        reset_result = reset_db()
        expect(reset_result).to eq(0), "Failed to reset the database. Delete operation failed."
    end

    it 'allows inserting strings that are the maximum length' do
        long_username = "a"*32
        long_email = "a"*225
        script = [
            "insert 1 #{long_username} #{long_email}",
            "select",
            ".exit",
        ]
        result = run_script(script)
        expect(result).to match_array([
            "db > Executed.",
            "db > (1, #{long_username}, #{long_email})",
            "Executed.",
            "db > ",
        ])

        # Reset the database
        reset_result = reset_db()
        expect(reset_result).to eq(0), "Failed to reset the database. Delete operation failed."
    end

    it 'prints error message if strings are too long' do
        long_username = "a"*33
        long_email = "a"*256
        script = [
            "insert 1 #{long_username} #{long_email}",
            "select",
            ".exit",
        ]
        result = run_script(script)
        expect(result).to match_array([
            "db > String is too long.",
            "db > Executed.",
            "db > ",
        ])

        # Reset the database
        reset_result = reset_db()
        expect(reset_result).to eq(0), "Failed to reset the database. Delete operation failed."
    end

    it 'prints an error message if ID is negative' do 
        script = [
            "insert -1 cstack foo@bar.com",
            "select",
            ".exit",
        ]
        result = run_script(script)
        expect(result).to match_array([
            "db > ID must be positive.",
            "db > Executed.",
            "db > ",
        ])

        # Reset the database
        reset_result = reset_db()
        expect(reset_result).to eq(0), "Failed to reset the database. Delete operation failed."
    end

    it 'keeps data after closing connection' do 
        result1 = run_script([
            "insert 1 foo foo@bar.com",
            ".exit"
        ])
        expect(result1).to match_array([
            "db > Executed.",
            "db > ",
        ])
        result2 = run_script([
            "select",
            ".exit",
        ])
        expect(result2).to match_array([
            "db > (1, foo, foo@bar.com)",
            "Executed.",
            "db > ",
        ])

        # Reset the database
        reset_result = reset_db()
        expect(reset_result).to eq(0), "Failed to reset the database. Delete operation failed."
    end

    it 'allows printing out the structure of a one-node btree' do
        script = [3, 1, 2].map do |i|
          "insert #{i} user#{i} person#{i}@example.com"
        end
        script << ".btree"
        script << ".exit"
        result = run_script(script)
    
        expect(result).to match_array([
          "db > Executed.",
          "db > Executed.",
          "db > Executed.",
          "db > Tree:",
          "leaf (size 3)",
          "  - 0 : 3",
          "  - 1 : 1",
          "  - 2 : 2",
          "db > "
        ])
    end
    
    it 'prints constants' do
        script = [
          ".constants",
          ".exit",
        ]
        result = run_script(script)
    
        expect(result).to match_array([
          "db > Constants:",
          "ROW_SIZE: 293",
          "COMMON_NODE_HEADER_SIZE: 6",
          "LEAF_NODE_HEADER_SIZE: 10",
          "LEAF_NODE_CELL_SIZE: 297",
          "LEAF_NODE_SPACE_FOR_CELLS: 4086",
          "LEAF_NODE_MAX_CELLS: 13",
          "db > ",
        ])
    end
end