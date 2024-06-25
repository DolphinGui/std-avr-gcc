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
    patch=3
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
            file = "root.tar.xz"
        elif self._settings_build.os == "Windows":
            file = "winroot.tar.xz"
        download(self,
            f'https://github.com/DolphinGui/std-avr-gcc/releases/download/v{self.major}.{self.minor}.{self.patch}-alpha/{file}',
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

        resource_dir = os.path.join(self.package_folder, "res/")
        copy(self, pattern="toolchain.cmake", src=self.build_folder,
             dst=resource_dir, keep_path=True)

    def package_info(self):
        bindir = os.path.join(self.package_folder, "bin")

        script_suffix = ""
        exe_suffix = ""
        if self._settings_build.os == "Linux":
            script_suffix = ".sh"
        else:
            script_suffix = ".ps1"
            exe_suffix = ".exe"

        self.cpp_info.includedirs = []
        self.cpp_info.bindirs = [bindir]
        self.buildenv_info.append_path("PATH", bindir)

        self.conf_info.define(
            "tools.cmake.cmaketoolchain:system_name", "Generic")
        self.conf_info.define(
            "tools.cmake.cmaketoolchain:system_processor", "avr")

        self.conf_info.define("tools.build.cross_building:can_run", False)
        self.conf_info.define("tools.build:compiler_executables", {
            "c":  f'avr-gcc{exe_suffix}',
            "cpp": f'avr-g++{script_suffix}',
            "asm": f'avr-as{exe_suffix}',
        })

        f = os.path.join(self.package_folder, "res/toolchain.cmake")
        self.conf_info.append("tools.cmake.cmaketoolchain:user_toolchain", f)

