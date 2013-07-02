#!/usr/bin/ruby
# Copies the snippets in current directory to the elpa yasnippet directory

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'fileutils'

elpa_dir = File.join(ENV['HOME'],".emacs.d","elpa")

yasnippet_dir = nil

#gets the yasnippet directory
Dir.foreach(elpa_dir) { |directory|
  if directory.include?("yasnippet")
    yasnippet_dir = File.join(elpa_dir,directory,"snippets")
  end
}

if not yasnippet_dir
  abort("No yasnippet directory in " + elpa_dir)
end

#misc files to copy over if found
copy_files = [".yas-parents",  ".yas-ignore-filenames-as-triggers", ".yas-make-groups"]

#our working directory is this script's directory
Dir.chdir(File.dirname(File.expand_path(__FILE__))) do
  #copies each subdirectory into that yasnippet directory
  Dir.foreach("."){ |directory|
    if File.directory?(directory) and directory != "." and directory != ".." and directory != ".git" 
      #gets (and makes, if necessary) its destination directory
      dest_dir = File.join(yasnippet_dir,directory)
      if not File.exists?(dest_dir)
        FileUtils.mkdir_p(dest_dir)
      end
     
      Dir.chdir(directory) do 
        Dir.foreach("."){ |file|
          #only copies .yasnippet files or certain copy_files
          if File.extname(file) == ".yasnippet" or copy_files.include?(file)
            FileUtils.copy(file,File.join(dest_dir,file))
          end
        }
      end
      
      puts "Copied from " + File.absolute_path(directory) + " to " + File.absolute_path(dest_dir)
    end
  }
end
