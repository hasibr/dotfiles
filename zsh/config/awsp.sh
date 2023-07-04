# Wrapper for _awsp executable (https://github.com/johnnyopao/awsp)
# Source in zshrc
# Workaround for awsp crashing terminal when installed using nodeenv: https://github.com/johnnyopao/awsp/issues/5#issuecomment-1426644971

# Call the original executable and have it write the desired AWS profile name to ~/.awsp
_awsp
# Read the selected profile from the ~/.awsp file
selected_profile="$(cat ~/.awsp)"

# Set the AWS_PROFILE environment variable for the shell session
if [ -z "$selected_profile" ]
then
  unset AWS_PROFILE
else
  export AWS_PROFILE="$selected_profile"
fi