#### SSH KEYS

# Get my keys
mkdir tmp
scp henrik@vx.hsw.no:.ssh/myconfig/id_henrist* tmp/
cp tmp/id_henrist* ~henrik/.ssh/
cp tmp/id_henrist* ~root/.ssh/

# Add public key
# TODO: check if key exists
cat tmp/id_henrist.pub >>~henrik/.ssh/authorized_keys
cat tmp/id_henrist.pub >>~root/.ssh/authorized_keys

# Set some permissions
chown henrik:henrik ~henrik/.ssh/authorized_keys ~henrik/.ssh/id_henrist*
chown root:root ~root/.ssh/authorized_keys ~root/.ssh/id_henrist*
chmod 600 ~henrik/.ssh/id_henrist ~root/.ssh/id_henrist
chmod 644 ~henrik/.ssh/id_henrist.pub ~root/.ssh/id_henrist.pub

# Remove keys from this dir
rm tmp -Rf
