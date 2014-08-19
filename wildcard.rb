#!/usr/bin/env ruby
#
require 'securerandom'
require 'fileutils'
require 'open3'

def show_banner 
    puts
    puts ' **      ** ** **********   ******    *******   ****     **   **     **'
    puts '/**     /**/**/////**///   **////**  **/////** /**/**   /**  //**   ** '
    puts '/**     /**/**    /**     **    //  **     //**/**//**  /**   //** **  '
    puts '/**********/**    /**    /**       /**      /**/** //** /**    //***   '
    puts '/**//////**/**    /**    /**       /**      /**/**  //**/**     **/**  '
    puts '/**     /**/**    /**    //**    **//**     ** /**   //****    ** //** '
    puts '/**     /**/**    /**     //******  //*******  /**    //***   **   //**'
    puts '//      // //     //       //////    ///////   //      ///   //     // '
    puts '                                                            by oldtrick'
    puts
    puts "Welcome to my shell. Just pwn to own."
end

def open_capture(cmd, args)
    o, s = Open3.capture2("#{cmd} #{args}")
    puts o if o.length > 0
end

def execute(cmdline)
    cmdline.chomp!
    cmdline.sub! /^\s+/, ""
    cmd, args = cmdline.split(" ", 2)
    # filtering
    if args and not args.match /^[0-9a-z\-\\ ]+$/i
        puts "Invalid character."
        return 1
    end

    case cmd
    when "exit"
        return 0
    when "help"
        puts "Command:\n\techo, exit, touch, cat, ls"
        puts "id - return user identity"
        puts "uname - display information about the system"
        puts "echo - write arguments to the standard output"
        puts "touch - change file access and modification times"
        puts "ls - list directory contents"
        puts "cat - concatenate and print files"
        puts "exit - backup your files and exit"
    when "cat"
        puts "Serious? Are you kidding me?!"
    when "echo"
        open_capture cmd, args
    when "touch"
        open_capture cmd, args
    when "ls"
        open_capture cmd, args
    when "id"
        open_capture cmd, args
    when "uname"
        open_capture cmd, args
    else
        puts "shell: #{cmd}: Command not found."
    end
    return 1
end

def interactive(folder)
	loop do
	    STDOUT.write "$ " 
	    STDOUT.flush
	    break if STDIN.eof?
            # exec commands
	    break if execute(STDIN.gets) == 0
	end
end

def zipfile_and_exit(folder)
    begin
        puts ""
        puts "Start zipping file..."
        o, s = Open3.capture2("zip takeaway.zip * -x flag")
        puts o
        puts "Done."
        puts 
        puts "Did you forget to catch the flag?"
        puts 
        puts "Bye!"
    rescue
    end
    FileUtils.rm_rf "../#{folder}"
end

if __FILE__ == $0
    temp_folder = ""

    loop do
    	Dir.chdir "/home/overthere/data"

    	temp_folder = "wildcard_"
    	temp_folder << SecureRandom.hex

	break if not Dir.exist? temp_folder
    end

    FileUtils.mkdir temp_folder
    FileUtils.chmod 0777, temp_folder
    FileUtils.cp("/home/judge/flag",temp_folder)
    FileUtils.touch("#{temp_folder}/atdog_said_it's_easy")
    Dir.chdir temp_folder

    show_banner

    interactive temp_folder
    
    zipfile_and_exit temp_folder
end
