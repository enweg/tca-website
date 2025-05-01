using DocUtils
using LibGit2
using JSON

git_toolbox_url = "git@github.com:enweg/tca-matlab-toolbox.git"
temp_dir = mktempdir()
LibGit2.clone(git_toolbox_url, temp_dir)

functions, classes, class_methods = extract_matlab_info(temp_dir, "tests/*")

function save_to_json(filename, dict)
  open(filename, "w") do file 
    JSON.print(file, dict)
  end
end

save_to_json("matlab-documentation-functions.json", functions)
save_to_json("matlab-documentation-classes.json", classes)
save_to_json("matlab-documentation-class-methods.json", class_methods)

# Can be read back in using 
# function load_from_json(filename)
#   dict = open(filename, "r") do file 
#     JSON.parse(file)
#   end
#   return dict
# end

