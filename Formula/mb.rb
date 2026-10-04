class Mb < Formula
  include Language::Python::Virtualenv

  desc "Micro.blog command-line client and MCP server for agents"
  homepage "https://github.com/jthingelstad/mb"
  url "https://github.com/jthingelstad/mb/archive/34263c38b5e76037b8d71ab0409427e6fefe82a8.tar.gz"
  version "2.0.0"
  sha256 "4a448c09acbe21024f05b1c6b26e107f43252045b5411e16b2f01e09dcee82ee"
  license "MIT"
  deny_network_access! [:build, :test]

  depends_on :macos => :tahoe
  depends_on arch: :arm64
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jpeg-turbo"
  depends_on "libffi"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "webp"

  # Keep the resolver on the reviewed release lock, including MCP extras.
  pypi_packages package_name:   "mb[mcp]",
                extra_packages: %w[
                  annotated-doc==0.0.4
                  annotated-types==0.8.0
                  anyio==4.14.2
                  attrs==26.1.0
                  certifi==2026.6.17
                  cffi==2.1.1
                  click==8.4.2
                  cryptography==50.0.2
                  h11==0.16.0
                  httpcore==1.0.9
                  httpcore2==2.13.1
                  httpx==0.28.1
                  httpx2==2.13.1
                  idna==3.18
                  jsonschema==4.26.0
                  jsonschema-specifications==2025.9.1
                  markdown-it-py==4.2.0
                  mcp==2.3.0
                  mcp-types==2.3.0
                  mdurl==0.1.2
                  opentelemetry-api==1.45.0
                  pillow==12.3.0
                  pycparser==3.0
                  pydantic==2.13.5
                  pydantic-core==2.46.5
                  pygments==2.20.0
                  pyjwt==2.15.1
                  python-multipart==0.0.32
                  referencing==0.37.0
                  rich==15.0.0
                  rpds-py==2026.6.3
                  shellingham==1.5.4
                  sse-starlette==3.5.0
                  starlette==1.7.0
                  truststore==0.10.4
                  typer==0.27.0
                  typing-extensions==4.16.0
                  typing-inspection==0.4.4
                  uvicorn==0.54.0
                ]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/5f/56/a8120250d128bed162cd73c76d45f6ef9991f3e068f62a8ee060afa3104a/annotated_types-0.8.0.tar.gz"
    sha256 "13b2beaad985e05e2d6407ee4c4f35590b11f8d693a258a561055cac8f64cab7"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c9/c7/424b75da314c1045981bd9777432fad05a9e0c69daa4ed7e308bbaffe405/certifi-2026.6.17.tar.gz"
    sha256 "024c88eeec92ca068db80f02b8b07c9cef7b9fe261d1d535abfd5abd6f6af432"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9d/af/182eb91b0df3fe75c4d9f26fe70684569566745f6ba7e5c9c73a862c5252/cryptography-50.0.2.tar.gz"
    sha256 "7b46165bb56eb4704e2eaaf86f3c940d19154535d9b0ca7d6d590b04060e00d5"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/cb/f3/1db7aa2bc2524062192bb0e0323969492d1883152a232fe36eea65f4e35c/httpcore2-2.13.1.tar.gz"
    sha256 "e0aa977abe17e69a3b820a24542a6fa88702676d83880b8d194dcd18408e5103"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/d5/44/474bef2a0e9d90f1715d32cb98b0738695ca17ba324095fb2497ed7fbd59/httpx2-2.13.1.tar.gz"
    sha256 "e48744a19e3af5ee48313d0ce5fe941d5422fae5705ea922a4aabf94d7800dfa"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/9d/8d/e0d339616f4810e9051d4aba6887afab289ab1f81875fe908b606cdfd0e3/mcp-2.3.0.tar.gz"
    sha256 "8b147a50441cf059dc88c684e0aeed3687f0aa0f39c6cde7b90330effd2b34d8"
  end

  resource "mcp-types" do
    url "https://files.pythonhosted.org/packages/9e/2d/7c251e34207f6c51000312fc8839111ac45cfe02023f90b44e7f1051dd8e/mcp_types-2.3.0.tar.gz"
    sha256 "d1e46549edb35ee19a94940fcee6d1addd7e589ab7ea92dda83f5d84781fc362"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/1f/dc/e12c1fe1ed8a7b7149777127b1a0e12ce5bd5a81d97408bedc2128c260f5/opentelemetry_api-1.45.0.tar.gz"
    sha256 "711ede81773c8025c2c03dac0450bc89f3d30aea6eabcc815c570d4e35a963f7"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/1c/3d/bb7fca845737cf9d7dbde16ed1843984665ff2e0a518f5db43e77ec540b9/pillow-12.3.0.tar.gz"
    sha256 "3b8182a766685eaa002637e28b4ec8d6b18819a0c71f579bf0dbaa5830297cce"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/53/ef/fc4f868f4e2cee79f863883abffceff107875f569b848507319842d2a681/pydantic-2.13.5.tar.gz"
    sha256 "51a9c5f7b2f8e636f04c6cada605d9b6a3bf1348fdf945a3d8869b19bba0ee08"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/af/f9/8a06bea35ef8daf588f707784c973a7046e0034c8d8cfb08828eeffb8b75/pydantic_core-2.46.5.tar.gz"
    sha256 "10416c15b8839ecc4ef4d0885da76da6fd0f67333a0eb8aff6d93c4b8f2910fc"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/aa/2a/9618a122aeb2a169a28b03889a2995fe297588964333d4a7d67bdf46e147/rpds_py-2026.6.3.tar.gz"
    sha256 "1cebd1337c242e4ec2293e541f712b2da849b29f48f0c293684b71c0632625d4"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/e4/be/0123026f719d1a7936f214a88b553bb5701e04ff2511147c1dab0c5035eb/sse_starlette-3.5.0.tar.gz"
    sha256 "75de713aa8a9441513cc283220826da079d982770965b951e9437720e8bafdb2"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/7b/2b/3850dc6bf7ef71b088962eba31dafc6cffd2f96e577ebb0bb316df96da3e/starlette-1.7.0.tar.gz"
    sha256 "c79f74ea63cff761804fbbfb182f1e0b440c2d07b164d24700c5a1bab5d6ff5d"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/37/78/fda3361b56efc27944f24225f6ecd13d96d6fcfe37bd0eb34e2f4c63f9fc/typer-0.27.0.tar.gz"
    sha256 "629bd12ea5d13a17148125d9a264f949eb171fb3f120f9b04d85873cab054fa5"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/a3/26/b09b8010994eccc3c09092e6b34058f36a460eea2d4c3e8b910c695975a0/typing_inspection-0.4.4.tar.gz"
    sha256 "547274fa6b0a561ccf549cc9524b999a578e737d015d8709d021f9d0d13bea47"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "build-calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "build-cffi" do
    url "https://files.pythonhosted.org/packages/9e/ef/008a1939e372c06329a3fce4279c02f328488f3526744906eeec3da7ad5f/cffi-2.1.1.tar.gz"
    sha256 "dd31f52ea1086513bb9df30f8fcee9b8918323ae067a3d5b78bc826a000712be"
  end

  resource "build-cmake" do
    url "https://files.pythonhosted.org/packages/02/65/6cd38c1ee4292d4e91a7700ef827afdad365f981589db1750a2b74c84685/cmake-4.4.3.tar.gz"
    sha256 "b0c2703ec0a624649dd184c0ac5ee4c7f5fe5ef35eb82f9da44f5a0903adb2b6"
  end

  resource "build-dunamai" do
    url "https://files.pythonhosted.org/packages/12/18/020d3b27a10450ddb11429f637404e8ea67ecf4d9fd999d4f1d553f25506/dunamai-1.26.2.tar.gz"
    sha256 "84ea45eddf9bb4b40df7610b1b22a03137365e6257dbf9d7b72128fdccca564c"
  end

  resource "build-flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "build-hatch-fancy-pypi-readme" do
    url "https://files.pythonhosted.org/packages/f3/0f/aed57c301f339936eb91cb4d8c1e5088a101081854bd3ec18a889df32365/hatch_fancy_pypi_readme-25.1.0.tar.gz"
    sha256 "9c58ed3dff90d51f43414ce37009ad1d5b0f08ffc9fc216998a06380f01c0045"
  end

  resource "build-hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "build-hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "build-jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "build-markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "build-maturin" do
    url "https://files.pythonhosted.org/packages/b9/c8/22e5e21b2679c9bce6415ca578034ca2cc9316be0642ae21e051a2d5198c/maturin-1.15.0.tar.gz"
    sha256 "94b26cc8e8aba61a5f2099715fe640e18c5f678e9a500408b38761263954228a"
  end

  resource "build-ninja" do
    url "https://files.pythonhosted.org/packages/ac/92/410b7917d16ab54c04b05cc32b9284803671d91cf79d33be6009c28d4ea8/ninja-1.13.2.tar.gz"
    sha256 "525bfa3fc88aa30a4467df270fd5be6f9fcae8061d54d4df74ea1dc5abd5a975"
  end

  resource "build-packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "build-pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "build-pdm-backend" do
    url "https://files.pythonhosted.org/packages/fc/d5/a82f533ed51f91a2183faf67a1fcb3b759615ffeca95d05b3e7648bf84bf/pdm_backend-2.5.0.tar.gz"
    sha256 "7953b994563d3151755e3364b9d0cfe817ed0eaecdf27c8f777f412d26bcd98a"
  end

  resource "build-pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "build-poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "build-pybind11" do
    url "https://files.pythonhosted.org/packages/76/f3/95b0f40b31df41dbfe6bb0857419c9442c15839cbac4796f1c26ae0b6081/pybind11-3.1.0.tar.gz"
    sha256 "a1cc06b524ab3edca51f8ad3895f9c4fa20b8b19283173dff4ae781449dc9639"
  end

  resource "build-pycparser" do
    url "https://files.pythonhosted.org/packages/1b/7d/92392ff7815c21062bea51aa7b87d45576f649f16458d78b7cf94b9ab2e6/pycparser-3.0.tar.gz"
    sha256 "600f49d217304a5902ac3c37e1281c9fe94e4d0489de643a9504c5cdfdfc6b29"
  end

  resource "build-scikit-build-core" do
    url "https://files.pythonhosted.org/packages/b2/1a/8c00b19c0a1e7acf890676af2efa430339d38e59fa9437f2aab8517af3f4/scikit_build_core-1.1.1.tar.gz"
    sha256 "e347a59193c878ac56a363e57506938652a6dd8c965790cb1cbc6bc7e8d5abad"
  end

  resource "build-semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "build-setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "build-setuptools-rust" do
    url "https://files.pythonhosted.org/packages/68/ba/b31781d61bf9ee3c232a1d1160db11c11cdeae1d44e06c90723b25a8279f/setuptools_rust-1.13.0.tar.gz"
    sha256 "f2afcf4baeee689910ce49cfa8aad4e08cce72f417449bcc32891b8664fdc726"
  end

  resource "build-setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "build-tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "build-trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "build-uv-dynamic-versioning" do
    url "https://files.pythonhosted.org/packages/6f/c8/fa500ee29af69cfeeea5ff6d6597919f1989b2e3f1a236c3006bdb21d320/uv_dynamic_versioning-0.14.1.tar.gz"
    sha256 "8642db686ce5c50417035e7a257ac73b7e5c3a7a32c33e45bd7e36ba22eeb648"
  end

  resource "build-vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "build-wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "cargo-vendor" do
    url "https://github.com/jthingelstad/mb/releases/download/homebrew-build-inputs-v1/mb-cargo-vendor-v1.tar.gz"
    sha256 "dec9b4d48a793d92eada269ce7f1d128ec24ea9a54b91a70351d9c1fa5c361bf"
  end

  def install
    # Reviewed source-input closure; the hosted workflow verifies cold install/upgrade/pour.
    # Pip build isolation resolves only declared, Homebrew-checksummed sources.
    build_inputs = %w[build-calver build-cffi build-cmake build-dunamai build-flit-core build-hatch-fancy-pypi-readme build-hatch-vcs build-hatchling build-jinja2 build-markupsafe build-maturin build-ninja build-packaging build-pathspec build-pdm-backend build-pluggy build-poetry-core build-pybind11 build-pycparser build-scikit-build-core build-semantic-version build-setuptools build-setuptools-rust build-setuptools-scm build-tomlkit build-trove-classifiers build-uv-dynamic-versioning build-vcs-versioning build-wheel]
    backend_sources = buildpath/"backend-sources"
    backend_sources.mkpath
    build_inputs.each do |name|
      input = resource(name)
      FileUtils.cp input.cached_download, backend_sources/File.basename(input.url)
    end
    ENV["PIP_NO_INDEX"] = "1"
    ENV["PIP_FIND_LINKS"] = backend_sources.to_s
    ENV["MATURIN_NO_INSTALL_RUST"] = "1"
    ENV["MATURIN_PEP517_ARGS"] = "--locked"
    ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = ENV.make_jobs.to_s
    ENV["CMAKE_EXECUTABLE"] = (Formula["cmake"].opt_bin/"cmake").to_s
    ENV["CMAKE_MAKE_PROGRAM"] = (Formula["ninja"].opt_bin/"ninja").to_s
    ENV.prepend_path "PATH", Formula["cmake"].opt_bin
    ENV.prepend_path "PATH", Formula["ninja"].opt_bin
    # Use only source archives bound to the upstream Cargo.lock checksums.
    cargo_vendor = buildpath/"cargo-vendor"
    cargo_vendor.mkpath
    resource("cargo-vendor").stage { cargo_vendor.install Dir["*"] }
    cargo_home = buildpath/"cargo-home"
    cargo_home.mkpath
    (cargo_home/"config.toml").write <<~TOML
      [source.crates-io]
      replace-with = "mb-vendored"
      [source.mb-vendored]
      directory = #{cargo_vendor.to_s.dump}
      [net]
      offline = true
    TOML
    ENV["CARGO_HOME"] = cargo_home.to_s
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["CARGO_BUILD_JOBS"] = ENV.make_jobs.to_s
    cargo_wrapper = buildpath/"build-tools/cargo"
    cargo_wrapper.dirname.mkpath
    cargo_wrapper.write <<~SH
      #!/bin/bash
      set -euo pipefail
      needs_lock=false
      for arg in "$@"; do
        case "$arg" in
          --locked|--frozen) exec "#{Formula["rust"].opt_bin}/cargo" "$@" ;;
          build|check|fetch|metadata|rustc|test) needs_lock=true ;;
        esac
      done
      if "$needs_lock"; then
        exec "#{Formula["rust"].opt_bin}/cargo" "$@" --locked
      fi
      exec "#{Formula["rust"].opt_bin}/cargo" "$@"
    SH
    cargo_wrapper.chmod 0755
    ENV["CARGO"] = cargo_wrapper.to_s
    ENV.prepend_path "PATH", cargo_wrapper.dirname
    # Reviewed backend pins; keep build resolution separate from runtime resources.
    (buildpath/"brew-build-constraints.txt").write <<~EOS
      calver==2025.10.20
      cffi==2.1.1
      cmake==4.4.3
      dunamai==1.26.2
      flit-core==3.12.0
      hatch-fancy-pypi-readme==25.1.0
      hatch-vcs==0.5.0
      hatchling==1.32.4
      jinja2==3.1.6
      markupsafe==3.0.4
      maturin==1.15.0
      ninja==1.13.2
      packaging==26.3
      pathspec==1.1.1
      pdm-backend==2.5.0
      pluggy==1.6.0
      poetry-core==2.5.0
      pybind11==3.1.0
      pycparser==3.0
      scikit-build-core==1.1.1
      semantic-version==2.10.0
      setuptools==84.0.0
      setuptools-rust==1.13.0
      setuptools-scm==10.3.4
      tomlkit==0.15.1
      trove-classifiers==2026.9.21.13
      uv-dynamic-versioning==0.14.1
      vcs-versioning==2.5.0
      wheel==0.48.0
    EOS
    ENV["PIP_BUILD_CONSTRAINT"] = (buildpath/"brew-build-constraints.txt").to_s
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3").to_s
    virtualenv_install_with_resources without: build_inputs + ["cargo-vendor"], system_site_packages: false
    pkgshare.install "tests/mcp_fixture.py"
  end

  test do
    ENV.delete "MB_TOKEN"
    ENV.delete "MB_BLOG"
    ENV.delete "PYTHONPATH"
    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/".config").to_s
    (testpath/"installed-test.py").write <<~PYTHON
      """Homebrew functional test: installed modules, fake HTTP, isolated state only."""
      import importlib.metadata
      from importlib.resources import files
      import json
      import os
      from pathlib import Path
      import socket
      import subprocess
      import sys
      
      import anyio
      from mcp import ClientSession, StdioServerParameters
      from mcp.client.stdio import stdio_client
      from PIL import Image, features
      
      root = Path.cwd()
      executable = sys.argv[1]
      fixture = sys.argv[2]
      
      # No live socket is needed by this test or its stdio child.
      def refuse_network(*args, **kwargs):
          raise AssertionError('The installed functional test must never contact a live service')
      
      socket.socket.connect = refuse_network
      env = {k: v for k, v in os.environ.items() if k not in {'MB_TOKEN', 'MB_BLOG', 'PYTHONPATH'}}
      env.update(HOME=str(root), XDG_CONFIG_HOME=str(root / '.config'))
      assert importlib.metadata.version('mb') == '2.0.0'
      assert files('mb.guidance').joinpath('mcp.md').is_file()
      import mb
      assert '/src/mb/' not in str(Path(mb.__file__).resolve()), mb.__file__
      for args in [['--help'], ['guide'], ['mcp', '--help']]:
          result = subprocess.run([executable, *args], capture_output=True, text=True, env=env, timeout=30)
          assert result.returncode == 0, result.stderr
      result = subprocess.run([executable, '--format', 'json', 'whoami'], capture_output=True,
                              text=True, env=env, timeout=30)
      assert result.returncode == 1 and json.loads(result.stdout)['ok'] is False
      assert not (root / '.config/mb/config.toml').exists()
      for name in ['jpg', 'webp', 'zlib']:
          assert features.check(name), name
      Image.new('RGB', (3, 4), 'blue').save(root / 'image.png')
      
      async def run():
          # Catalog/resource handshake through the actual installed entrypoint, no token.
          params = StdioServerParameters(command=executable,
              args=['mcp', '--consumer', 'brew-static', '--read-only', '--state-file', str(root / 'static.sqlite')],
              cwd=str(root), env=env)
          async with stdio_client(params) as (read, write):
              async with ClientSession(read, write, read_timeout_seconds=30) as session:
                  initialized = await session.initialize()
                  assert initialized.server_info.name == 'mb'
                  tools = (await session.list_tools()).tools
                  assert len(tools) == 23 and all(t.input_schema and t.output_schema for t in tools)
                  for tool in tools:
                      if tool.name in {'post_create','post_reply','post_edit','post_delete','post_publish','media_upload'}:
                          assert 'operation_id' in tool.input_schema['required']
                  guide = await session.read_resource('mb://guide')
                  assert 'checkpoint_ack' in guide.contents[0].text
          assert not (root / 'static.sqlite').exists()
      
          # The fixture changes only transport and config; it imports installed MB.
          params = StdioServerParameters(command=sys.executable,
              args=[fixture, 'mcp', '--consumer', 'brew-synthetic', '--media-root', str(root),
                    '--state-file', str(root / 'synthetic.sqlite')],
              cwd=str(root), env={**env, 'MB_TEST_DIR': str(root), 'MB_TEST_OPAQUE_FEED': '1'})
          async with stdio_client(params) as (read, write):
              async with ClientSession(read, write, read_timeout_seconds=30) as session:
                  await session.initialize()
                  async def call(name, args):
                      result = await session.call_tool(name, args)
                      assert not result.is_error, result
                      return result.structured_content
                  async def consume():
                      ids = []
                      cursor = None
                      for _ in range(6):
                          args = {'count':2, **({'cursor':cursor} if cursor else {})}
                          page = (await call('catchup', args))['data']
                          ids.extend(item['id'] for item in page['items'])
                          cursor = page['next_cursor']
                          if not cursor:
                              assert page['coverage_complete']
                              return ids, page
                      raise AssertionError('Synthetic catchup did not terminate')
                  ids, page = await consume()
                  assert ids == ['9', '3', '7', '2', '8', '1']
                  assert (await call('checkpoint_ack', {'receipt':page['ack_receipt']}))['data']['checkpoint'] == '9'
                  preview = (await call('media_preview', {'file':'image.png','alt':'Blue rectangle'}))['data']
                  assert (preview['width'], preview['height']) == (3, 4)
                  args = {'file':'image.png','alt':preview['alt'],'sha256':preview['sha256'],
                          'operation_id':'brew-image-v1'}
                  uploaded = await call('media_upload', args)
                  assert uploaded['outcome'] == 'applied'
                  assert (await call('media_upload', args))['data']['url'] == uploaded['data']['url']
                  payload = {'content':'Synthetic image draft','photo_url':uploaded['data']['url'],
                             'photo_alt':preview['alt'],'draft':True}
                  assert (await call('post_preview', payload))['data']['photo_alt'] == 'Blue rectangle'
                  created = await call('post_create', {**payload,'operation_id':'brew-draft-v1'})
                  assert created['outcome'] == 'applied'
                  ids, page = await consume()
                  assert ids == ['4']
                  receipt = {'receipt':page['ack_receipt']}
                  assert (await call('checkpoint_ack', receipt))['data']['checkpoint'] == '4'
                  assert (await call('checkpoint_ack', receipt))['data']['already_applied']
                  source = (await call('post_get', {'identifier':created['data']['url']}))['data']
                  assert source['properties']['post-status'] == ['draft']
                  assert source['properties']['mp-photo-alt'] == ['Blue rectangle']
                  assert (await call('operation_status', {'operation_id':'brew-draft-v1'}))['outcome'] == 'applied'
          print('Installed CLI, no-auth refusal, MCP 23-tool handshake/guide, JPEG/WebP, native-order catchup/lower-ID ack, and synthetic image-to-draft/receipt replay passed.')
      
      anyio.run(run)
      
      # Installed CLI with synthetic transport; no explicit ID needed.
      command = [sys.executable, fixture, '--format', 'json', '--state-file', str(root/'human.sqlite')]
      result = subprocess.run([*command, 'post', 'new', 'Synthetic human post'], capture_output=True, text=True, env={**env,'MB_TEST_DIR':str(root)}, timeout=30)
      assert result.returncode == 0, result.stderr
      receipt = json.loads(result.stdout)
      assert receipt['operation_id'].startswith('cli-') and receipt['outcome'] == 'applied'
      result = subprocess.run([*command, 'operation-status', '--latest'], capture_output=True, text=True, env={**env,'MB_TEST_DIR':str(root)}, timeout=30)
      assert result.returncode == 0, result.stderr
      assert json.loads(result.stdout)['operation_id'] == receipt['operation_id']
      print('Installed RC4: optional human CLI ID, durable receipt/latest recovery and required MCP IDs passed.')
    PYTHON
    system libexec/"bin/python", testpath/"installed-test.py", bin/"mb", pkgshare/"mcp_fixture.py"
  end
end
