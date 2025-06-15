import ProjectDescription

let project = Project(
    name: "gitit-tuist",
    targets: [
        .target(
            name: "gitit-tuist",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.gitit-tuist",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [:],
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ]
                ]
            ),
            sources: ["gitit-tuist/Sources/**"],
            resources: ["gitit-tuist/Resources/**"],
            dependencies: []
        ),
        
        .target(
            name: "gitit-tuistTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.gitit-tuistTests",
            infoPlist: .default,
            sources: ["gitit-tuist/Tests/**"],
            resources: [],
            dependencies: [.target(name: "gitit-tuist")]
        ),
    ]
)
