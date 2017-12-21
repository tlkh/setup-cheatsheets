Site Migration (Wordpress)

Install wp-cli:
`curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar`
`chmod +x wp-cli.phar`
`sudo mv wp-cli.phar /usr/local/bin/wp`
`wp --info`

`wp search-replace 'https://' 'http://' --skip-columns=guid`

`wp user create admin_name admin@gmail.com --role='administrator'`

`wp user delete $(wp user list --role=blogger --field=ID) --reassign=47222`

https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04

Optimise database

#!/bin/bash
for ((number=1;number < 100;number++))
{
if (( $number % 5 == 0 ))
then
echo "$number is divisible by 5 "
fi
}
exit 0