{
  lib,
  buildGoModule,
  fetchFromGitHub,
  protobuf,
  protoc-gen-go,
  protoc-gen-go-grpc,
  grpc-gateway,
  buf,
  gnumake,
}:

buildGoModule rec {
  pname = "ops";
  version = "unstable-2024-01-20";

  src = fetchFromGitHub {
    owner = "nanovms";
    repo = "ops";
    rev = "36fcd46119fd5b3cc7c5a9128758927b58ddc9b7";
    sha256 = "sha256-8VRdeuXCkxo+0PioYb1pUsFBE+e+TgNIKD5t7vgmEmQ=";
  };

  proxyVendor = true;
  vendorHash = "sha256-M+2k7K4HDRP0Qo78t9H1Pg1XkIqrjjNAOTgF1kXJmMk=";

  nativeBuildInputs = [
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    grpc-gateway
    buf
    gnumake
  ];

  env.GOWORK = "off";

  preBuild = ''
    echo "Running 'make generate' to create Protocol Buffer code..."
    make generate
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