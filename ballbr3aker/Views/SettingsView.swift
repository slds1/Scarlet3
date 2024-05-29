//
//  SettingsView.swift
//  Scarlet 3
//
//  Created by Salupov Tech on 5/18/24.
//

import SwiftUI
import SystemConfiguration.CaptiveNetwork

// Define the ExploitType enum with CaseIterable and Identifiable protocols
enum ExploitType: String, CaseIterable, Identifiable {
    case type1 = "Эпл Сервера"
    case type2 = "Наши Сервера"
    case type3 = "Сторонние Сервера"
    
    var id: String { self.rawValue }
}

enum ScarletVersion: String, CaseIterable, Identifiable {
    case type1 = "3.3"
    case type2 = "3.0 beta"
    case type3 = "2.0.2"
    case type4 = "1.0"
    
    var id: String { self.rawValue }
}

enum RazmerHuya: String, CaseIterable, Identifiable {
    case type1 = "0 cm"
    case type2 = "10 cm"
    case type3 = "15 cm"
    case type4 = "1488 mm"
    
    var id: String { self.rawValue }
}

// Define the ColorSchemeOption enum with CaseIterable and Identifiable protocols
enum ColorSchemeOption: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { self.rawValue }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

// Define the AppSettings class to manage app settings using @AppStorage for persistence
class AppSettings: ObservableObject {
    @AppStorage("colorScheme") var colorScheme: ColorSchemeOption = .system
    @AppStorage("exploitType") var exploitType: ExploitType = .type1
    @AppStorage("razmerHuya") var razmerHuya: RazmerHuya = .type1
    @AppStorage("scarletVersion") var scarletVersion: ScarletVersion = .type1
    @AppStorage("debuggerEnabled") var debuggerEnabled: Bool = false
    @AppStorage("memoryReadEnabled") var memoryReadEnabled: Bool = true
    @AppStorage("legacyPatchingEnabled") var legacyPatchingEnabled: Bool = false
    @AppStorage("ldrestartEnabled") var ldrestartEnabled: Bool = true
    @AppStorage("verboseEnabled") var verboseEnabled: Bool = false
}

// Define the SettingsView with environment object for settings
struct SettingsView: View {
    @EnvironmentObject var settings: AppSettings
    
    // List of registered UDIDs
    let registeredUDIDs = ["99BE736A-8CC6-458B-94B8-A7E17BCBE437", "123", "099A9EA1-79D8-4C02-A50F-26DA4DA0D764"]
    
    // State variable to control visibility of development options
    @State private var showDevelopmentOptions = false
    @State private var unlockCode = ""
    @State private var showingAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("ВИД")) {
                Picker("Схема цвета", selection: $settings.colorScheme) {
                    ForEach(ColorSchemeOption.allCases) { option in
                        Text(option.rawValue.capitalized).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Метод установки")) {
                Picker("Метод", selection: $settings.exploitType) {
                    ForEach(ExploitType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
            
            
            
            Section(header: Text("настройки")) {
                Toggle(isOn: $settings.legacyPatchingEnabled) {
                    Label("Отправка аналитики", systemImage: "hammer.fill")
                }
                .toggleStyle(SwitchToggleStyle(tint: .red))
                
                Toggle(isOn: $settings.debuggerEnabled) {
                    Label("Режим Тестирования", systemImage: "ant.fill")
                }
                .toggleStyle(SwitchToggleStyle(tint: .red))
                
                Toggle(isOn: $settings.memoryReadEnabled) {
                    Label("Защита Аккаунтов", systemImage: "cpu.fill")
                }
                .toggleStyle(SwitchToggleStyle(tint: .red))
                
                Toggle(isOn: $settings.ldrestartEnabled) {
                    Label("Быстрая Перезагрузка", systemImage: "restart.circle.fill")
                }
                .toggleStyle(SwitchToggleStyle(tint: .red))
                
                Picker("Версия Скарлет", selection: $settings.scarletVersion) {
                    ForEach(ScarletVersion.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
            
            if registeredUDIDs.contains(identifierForVendor()) {
                if showDevelopmentOptions {
                    Section(header: Text("для разработчиков")) {
                        Toggle(isOn: $settings.verboseEnabled) {
                            Label("онлайн залупа SalupovTeam", systemImage: "apple.terminal.fill")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .red))
                        
                        Button("Trigger Panic (16.4)", systemImage: "applewatch.case.inset.filled") {
                            UIApplication.shared.alert(title: "Panic triggered", body: "App will likely crash now if you have iOS 16.4.1 and higher", withButton: false)
                            trigger_memmove_oob_copy()
                        }
                        Button("Сервер с iCloud", systemImage: "cloud") {
                            UIApplication.shared.open(URL(string: "ПУСТО!!! ЫГЫГЫГЫГГЫ")!)
                        } // https://discord.gg/Rse9ZBZC
                    }
                } else {
                    Section(header: Text("Настройки разработчика")) {
                        SecureField("Ввести код разблокировки", text: $unlockCode)
                        Button("Отправить") {
                            checkUnlockCode()
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Неправильный код"), message: Text("Вы ввели неправильный код"), dismissButton: .default(Text("OK")))
                        }
                    }
                }
            } else {
                Section(header: Text("Настройки разработчика")) {
                    Text("Устройство не зарегестрировано")
                }
            }
            
            Section(header: Text("Создатели:")) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Приложение")
                        Text("Сделанно s0meyosh1no")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    Button("Ссылка") {
                        UIApplication.shared.open(URL(string: "https://t.me/realdotnofake")!)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Помощь с кодом")
                        Text("Сделанно latte_1")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    Button("Ссылка") {
                        UIApplication.shared.open(URL(string: "https://angelicanuses")!)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Методы Установки")
                        Text("Сделанно SalupovTeam")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    Button("Ссылка") {
                        UIApplication.shared.open(URL(string: "https://github.com/SalupovTeam")!)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Наш вебсайт")
                        Text("Сделан dolbaeb.me")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    Button("Вебсайт") {
                        UIApplication.shared.open(URL(string: "https://salupovteam.com/scarlet3")!)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                    
                    Button("Ссылка") {
                        UIApplication.shared.open(URL(string: "https://dolbaeb.me")!)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Наш спонсор")
                        Text("Alwwwd")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    
                    Button("Ссылка") {
                        UIApplication.shared.open(URL(string: "https://t.me/alwwwd")!)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Реклама")
                        Text("Сделанно latte_1")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    
                    Button("Ссылка") {
                        UIApplication.shared.open(URL(string: "https://t.me/angelicanuses")!)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 8))
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Спасибо всем!")
                        Text("llsc12 - respring bug from ballpa1n\nHaxi0 - ballsbr3aker app UI")
                            .font(.system(size: 12))
                            .opacity(0.5)
                    }
                }
            }
            
            Section(header: Text("Device Info")) {
                VStack(alignment: .leading) {
                    Text("Device Model: \(UIDevice.current.model)")
                    Text("iOS Version: \(UIDevice.current.systemVersion)")
                    Text("Device Type: \(deviceType())")
                    Text("UDID: \(identifierForVendor())")
                    if let ssid = getWiFiSSID() {
                        Text("Connected Network: \(ssid)")
                    } else {
                        Text("Connected Network: Not Available")
                    }
                    
                    let registrationStatus = registeredUDIDs.contains(identifierForVendor()) ? "Registered" : "Not Registered"
                    Text("Registration Status: \(registrationStatus)")
                }
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(settings.colorScheme.colorScheme)
    }
    
    private func deviceType() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    private func getWiFiSSID() -> String? {
        if let interfaces = CNCopySupportedInterfaces() as? [String] {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: AnyObject] {
                    return interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                }
            }
        }
        return nil
    }
    
    private func getStorageLeft() -> String {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            if let freeSize = attributes[.systemFreeSize] as? NSNumber {
                let bytes = freeSize.int64Value
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = [.useGB] // optional: restricts the units to GB only
                formatter.countStyle = .file
                return formatter.string(fromByteCount: bytes)
            }
        } catch {
            return "Error retrieving storage info"
        }
        return "Unknown"
    }

    private func identifierForVendor() -> String {
        UIDevice.current.identifierForVendor?.uuidString ?? "Unavailable"
    }
    
    private func checkUnlockCode() {
        // Example unlock code check, replace "1234" with your actual unlock code
        if unlockCode == "TEST" {
            showDevelopmentOptions = true
        } else {
            showingAlert = true
        }
    }
    
    
}


// Define the main app entry point
@main
struct MyApp: App {
    @StateObject private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .preferredColorScheme(settings.colorScheme.colorScheme)
        }
    }
}

// Define the ContentView as the main view of the app

// Preview provider for the SettingsView
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(AppSettings())
    }
}
