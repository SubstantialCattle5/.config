function obs_jazz

  # Get directory name argument
  set dirname $argv[1]

  # Check if argument is empty
  if test -z "$dirname"
    echo "Usage: obs_jazz <directory_name>"
    return
  end

  # Construct source directory path based on dirname
  set source_dir $dirname

  # Check if source folder exists
  if not test -d "$source_dir"
    echo "Source folder not found: $source_dir"
    return
  end

  set target_path "$HOME/Documents/Obsidian Vault/content"

  # Extract the second-to-last section of the directory name
  set -l directory_name (basename (dirname $dirname))

  # Create the target path with parents if needed
  mkdir -p "$target_path/$directory_name"
  if test $status -ne 0
    echo "Error creating target path: $target_path/$directory_name"
    return
  end

  # Copy content from source folder to target path
  cp -r "$source_dir"/* "$target_path/$directory_name"
  if test $status -ne 0
    echo "Error copying files"
    return
  end

  echo "Successfully created directory: $directory_name in $target_path"
end
