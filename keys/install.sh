#### SSH KEYS
# TODO: Using same key for root is probably a bad idea?

# Don't process if keyfile is existent
if [ -a ~/.ssh/id_henrist ]; then
	echo "Key file exists - skipping key install"
	exit 0
fi

# Get my keys
mkdir tmp
scp henrik@vx.hsw.no:.ssh/myconfig/id_henrist* tmp/
cp tmp/id_henrist* ~/.ssh/
#cp tmp/id_henrist* ~root/.ssh/

# Add public key
# TODO: check if key exists
cat tmp/id_henrist.pub >>~/.ssh/authorized_keys
#cat tmp/id_henrist.pub >>~root/.ssh/authorized_keys

# Set some permissions
#chown henrik:henrik ~henrik/.ssh/authorized_keys ~henrik/.ssh/id_henrist*
#chown root:root ~root/.ssh/authorized_keys ~root/.ssh/id_henrist*
chmod 600 ~/.ssh/id_henrist #~root/.ssh/id_henrist
chmod 644 ~/.ssh/id_henrist.pub #~root/.ssh/id_henrist.pub

# Remove keys from this dir
rm tmp -Rf

echo "You have to use ssh-agent og move id_henrist to id_rsa or find another solution to use the key."
