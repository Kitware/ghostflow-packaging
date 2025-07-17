set -e
set -x

do_install=1
while [ $# -gt 0 ]; do
  case "$1" in
    --install) do_install=1; shift;;
    --vendor) do_install=0; shift;;
    -*) echo "unrecognized option: $1"; shift;;
    *) break;;
  esac
done

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

# Create the tarball
if [ "${do_install}" -eq "1" ]; then
  # Install to /app/
  cargo install --frozen --path . --root /app/ || cargo install --frozen --path ${app} --root /app/
else
  cd ../
  tar --exclude .gitlab/ \
      --exclude .git/ \
      --exclude target/ \
      -cJ ./${app}-${ref} \
      -f ${app}-${ref}-vendored.tar.xz
  chmod 666 ${app}-${ref}-vendored.tar.xz
fi
