set -e
set -x

app=$1
ref=${2:-master}

# apt-get update -yqq

mkdir -p "${app}-${ref}"
cd "${app}-${ref}"

git init
git remote add origin https://gitlab.kitware.com/utils/${app}.git
git fetch --depth 1 origin ${ref}
git checkout FETCH_HEAD

# Build from lock file
if [ ! -f Cargo.lock ]; then
  cargo update
fi
cargo fetch --locked
mkdir -p .cargo/
cargo vendor > .cargo/config.toml

# Install to /app/
cargo install --frozen --path . --root /app/ || cargo install --frozen --path ${app} --root /app/

# Create the tarball
cd ../
tar --exclude .gitlab/ \
    --exclude .git/ \
    --exclude target/ \
    -cJ ./${app}-${ref} \
    -f ${app}-${ref}-vendored.tar.xz
chmod 666 ${app}-${ref}-vendored.tar.xz
