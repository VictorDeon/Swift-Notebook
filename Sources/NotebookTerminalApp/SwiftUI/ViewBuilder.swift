//

import SwiftUI
import Foundation
import ArgumentParser

struct ViewBuilderCommands: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "view-builder",
        abstract: "View builder com Swift UI"
    )

    @OptionGroup var common: CommonOptions

    mutating func run() async throws {
        await MainActor.run {
            let app = NSApplication.shared
            
            TerminalApp.showWindow(ViewBuilderContent(), by: app)
            app.run()

            print("Finalizado!")
        }
    }
}

fileprivate struct Excercise: Identifiable {
    let id = UUID()
    let name: String
    let reps: Int
    let weight: Int
}

fileprivate struct WorkoutBuilder<Content: View>: View {
    let columns = [
        GridItem(.fixed(150), alignment: .leading),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                content()
            }
        }
    }
}

fileprivate struct TextCustomModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content.font(.system(size: 15, weight: .semibold))
    }
}

fileprivate extension View {
    func tableHeaderTextStyle() -> some View {
        modifier(TextCustomModifier())
    }
}

fileprivate struct ViewBuilderContent: View {
    
    @State private var excercises = [
        Excercise(name: "Bench Press", reps: 10, weight: 50),
        Excercise(name: "Deadlift", reps: 10, weight: 60),
        Excercise(name: "Squats", reps: 20, weight: 80)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Workout Summary").font(.title)
            WorkoutBuilder {
                Text("Name").tableHeaderTextStyle()
                Text("Reps").tableHeaderTextStyle()
                Text("KGs").tableHeaderTextStyle()
                ForEach(excercises) { excercise in
                    Text(excercise.name)
                    Text("\(excercise.reps)")
                    Text("\(excercise.weight)")
                }
            }
        }
        .padding()
        .frame(width: 300, height: 300)
    }
}

