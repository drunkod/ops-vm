{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ops";
  version = "unstable-2024-01-20";

  src = fetchFromGitHub {
    owner = "nanovms";
    repo = "ops";
    rev = "36fcd46119fd5b3cc7c5a9128758927b58ddc9b7";
    sha256 = lib.fakeHash;
  };

  proxyVendor = true;
  vendorHash = lib.fakeHash; # Update this

  env.GOWORK = "off";

  # Skip the generate step if proto files are already committed
  preBuild = ''
    # Check if generated files already exist
    if [ ! -f "lepton/image_service.pb.go" ]; then
      echo "Warning: Proto files not pre-generated, build may fail"
    fi
  '';

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/nanovms/ops/lepton.Version=${version}"
  ];

  tags = [
    "aws"
    "azure"
    "do"
    "gcp"
    "hyperv"
    "ibm"
    "linode"
    "oci"
    "openshift"
    "openstack"
    "proxmox"
    "upcloud"
    "vbox"
    "vsphere"
    "vultr"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Build and run nanos unikernels";
    homepage = "https://github.com/nanovms/ops";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "ops";
  };
}