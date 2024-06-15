from conan import ConanFile
from conan.tools.files import get, copy, download, unzip
from conan.errors import ConanInvalidConfiguration
import os

# copied and modified from https://github.com/libhal-google/arm-gnu-toolchain/tree/main

required_conan_version = ">=1.60.2"


class AvrGnuToolchain(ConanFile):
    name = "avr-gnu-toolchain"
    license = ("GPL-3.0-only")
    # url = "https://github.com/conan-io/conan-center-index"
    # homepage = ""
    description = ("Conan installer for a patched GNU AVR embedded toolchain")
    topics = ("gcc", "compiler", "embedded", "avr")
    settings = "os", "arch", 'compiler', 'build_type'
    exports_sources = "toolchain.cmake"
    package_type = "application"
    major=0
    minor=6
    patch=2
    version = f"{major}.{minor}.{patch}"


    @property
    def _settings_build(self):
        return getattr(self, "settings_build", self.settings)

    def validate(self):
        supported_build_operating_systems = ["Linux", "Windows"]
        if not self._settings_build.os in supported_build_operating_systems:
            raise ConanInvalidConfiguration(
                f"The build os '{self._settings_build.os}' is not supported. "
                "Pre-compiled binaries are only available for "
                f"{supported_build_operating_systems}."
            )

        supported_build_architectures = {
            "Linux": ["x86_64"],
            "Windows": ["x86_64"]
        }

        if (
            not self._settings_build.arch
            in supported_build_architectures[str(self._settings_build.os)]
        ):
            build_os = str(self._settings_build.os)
            raise ConanInvalidConfiguration(
                f"The build architecture '{self._settings_build.arch}' "
                f"is not supported for {self._settings_build.os}. "
                "Pre-compiled binaries are only available for "
                f"{supported_build_architectures[build_os]}."
            )

    def source(self):
        pass

    def build(self):
        if  self._settings_build.os == "Linux":
            file = "root.tar.zstd"
        elif self._settings_build.os == "Windows":
            file = "winroot.tar.zstd"
        download(self,
            f'https://github.com/DolphinGui/avr-gcc-conantool/releases/download/v{self.major}.{self.minor}.{self.patch}-alpha/{file}',
            filename=file,
            verify=False)
        unzip(self, file)

    def package(self):
        if  self._settings_build.os == "Linux":
            dir = 'root'
        elif self._settings_build.os == "Windows":
            dir = 'winroot'
        copy(self, pattern="*",src=os.path.join(self.build_folder, dir),
             dst=self.package_folder, keep_path=True)

    def package_info(self):
        bindir = os.path.join(self.package_folder, "bin")

        script_suffix = ""
        exe_suffix = ""
        if self._settings_build.os == "Linux":
            script_suffix = ".sh"
        else:
            script_suffix = ".ps1"
            exe_suffix = ".exe"

        cc = os.path.join(bindir, f'avr-gcc{exe_suffix}')
        self.output.info("Creating CC env var with: " + cc)
        self.buildenv_info.define("CC", cc)

        cxx = os.path.join(bindir, f'avr-g++{script_suffix}')
        self.output.info("Creating CXX env var with: " + cxx)
        self.buildenv_info.define("CXX", cxx)

        ar = os.path.join(bindir, f'avr-gcc-ar{exe_suffix}')
        self.output.info("Creating AR env var with: " + ar)
        self.buildenv_info.define("AR", ar)

        nm = os.path.join(bindir, f"avr-gcc-nm{exe_suffix}")
        self.output.info("Creating NM env var with: " + nm)
        self.buildenv_info.define("NM", nm)

        ranlib = os.path.join(bindir, f"avr-gcc-ranlib{exe_suffix}")
        self.output.info("Creating RANLIB env var with: " + ranlib)
        self.buildenv_info.define("RANLIB", ranlib)

        strip = os.path.join(bindir, f"avr-strip{exe_suffix}")
        self.output.info("Creating STRIP env var with: " + strip)
        self.buildenv_info.define("STRIP", strip)
        
        self.buildenv_info.define("LDFLAGS", "-lfae")

        # TODO: Remove after conan 2.0 is released
        self.env_info.CC = cc
        self.env_info.CXX = cxx
        self.env_info.AR = ar
        self.env_info.NM = nm
        self.env_info.RANLIB = ranlib
