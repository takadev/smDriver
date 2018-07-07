import PackageDescription

let package = Package(
    name: "GD",
    pkgConfig: "gdlib",
    providers: [
        .brew(["gd"])
    ]
)
