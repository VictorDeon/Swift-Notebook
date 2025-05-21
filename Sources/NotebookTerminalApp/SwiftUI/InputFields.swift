import SwiftUI
import ArgumentParser

struct InputFieldCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "inputs",
        abstract: "Campos de preenchimento com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            TerminalApp.showWindow(InputFieldContentView(), by: app, title: "Formulario")
            app.run()

            print("Finalizado!")
        }
    }
}

struct InputFieldContentView: View {
    
    // Text fields
    @State private var username: String = ""
    @State private var password: String = ""
    
    // Single Select (Picker)
    let pickerOptions = ["Opção 1", "Opção 2", "Opção 3"]
    @State private var selectedOption: String = "Opção 1"
    
    // Multi-select via toggles
    let multiOptions = ["Item A", "Item B", "Item C"]
    @State private var selectedItems: Set<String> = []
    
    // Date, Time, DateTime
    @State private var selectedDate: Date = Date()
    @State private var selectedTime: Date = Date()
    @State private var selectedDateTime: Date = Date()
    
    // Radio buttons via segmented Picker
    let radioOptions = ["Red", "Green", "Blue"]
    @State private var selectedColor: String = "Red"
    
    // Checkbox
    @State private var isChecked: Bool = false
    
    // Slider (numeric input)
    @State private var sliderValue: Double = 50
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Username \(username) e Password \(password)")
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Divider()
                
                Text("Picker: \(selectedOption)")
                Picker("Selecione uma opção", selection: $selectedOption) {
                    ForEach(pickerOptions, id: \.self) { Text($0) }
                }.pickerStyle(MenuPickerStyle())
                
                Divider()
                
                Text("Multi-Select:")
                ForEach(multiOptions, id: \.self) { item in
                    Toggle(isOn: Binding(
                        get: { selectedItems.contains(item) },
                        set: { isOn in
                            if isOn { selectedItems.insert(item) } else { selectedItems.remove(item) }
                        }
                    )) {
                        Text(item)
                    }
                }
                Text("Selecionados: \(selectedItems.joined(separator: ", "))")
                
                Divider()
                
                DatePicker("Data", selection: $selectedDate, displayedComponents: .date)
                Text("Data: \(selectedDate)")
                DatePicker("Hora", selection: $selectedTime, displayedComponents: .hourAndMinute)
                Text("Hora: \(selectedDate)")
                DatePicker("Data e Hora", selection: $selectedDateTime)
                Text("Data e Hora: \(selectedDate)")
                
                Divider()
                
                Text("Radio Color: \(selectedColor)")
                Picker("Cor", selection: $selectedColor) {
                    ForEach(radioOptions, id: \.self) { Text($0) }
                }.pickerStyle(SegmentedPickerStyle())
                
                Divider()
                
                Toggle("Checkbox", isOn: $isChecked)
                Text(isChecked ? "Marcado" : "Desmarcado")
                
                Divider()
                
                Text("Slider: \(Int(sliderValue))")
                Slider(value: $sliderValue, in: 0...100)
                
            }
            .padding(10)
        }.frame(width: 300, height: 600, alignment: .center)
    }
}

