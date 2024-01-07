//
//  ContentView.swift
//  today
//
//  Created by Rafael on 1/6/24.
//

import SwiftUI

struct Task: Codable, Identifiable {
    var id = UUID()
    let task: String
    var due: Date = Date()
    var showingCal: Bool = false;
}

typealias TaskList = [Task]
extension TaskList: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(TaskList.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

struct ContentView: View {
    @AppStorage("tasks") var tasks: TaskList = [];
    @State var newTask: String = "";
    @State var hidden: Bool = false;
    
    var body: some View {
        ZStack{
            VStack {
                List {
                    ForEach(tasks.indices, id:\.self) { index in
                        HStack {
                            Text(tasks[index].task)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .blur(radius: hidden ? 2 : 0)
                            
                            Button (tasks[index].due.formatted(date: .numeric, time:.omitted)) {
                                tasks[index].showingCal = true
                            }
                            .frame(alignment: .trailing)
                            .popover(isPresented: $tasks[index].showingCal, content: {
                                DatePicker(
                                    "",
                                    selection: $tasks[index].due,
                                    displayedComponents: [.date]
                                )
                                .id(tasks[index].id)
                                .datePickerStyle(.graphical)
                            })
                            
                            Button { tasks.remove(at: index) } label: {
                                Text("\(Image(systemName:"trash"))")
                                    .padding(2)
                            }
                            .frame(alignment: .trailing)
                        }
                    }
                    .onMove(perform: { source, newOffset in
                        tasks.move(fromOffsets: source, toOffset: newOffset)
                    })
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                
                
                HStack {
                    TextField (text: $newTask) {
                    }.onSubmit {
                        tasks.append(Task(task: newTask))
                        newTask = ""
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 30, alignment: .bottom)
                
                
                HStack{
                    Button {
                        hidden = !hidden
                    } label: {
                        Text("\(Image(systemName: hidden ? "eye" : "eye.slash"))")
                            .padding(2)
                    }
                    
                    Button ("Close") {
                        NSApplication.shared.terminate(nil);
                    }
                }
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .padding(10)
    }
    
    func updateStatusBarTitle(title: String){
        AppDelegate.shared.statusBarItem?.button?.title = title
    }
}

#Preview{
    ContentView()
}
