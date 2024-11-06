//
//  writeLog.swift
//  Croak
//
//  Created by jeong hyein on 5/15/24.
//

import Foundation

func writeLog(_writeValue:String){
    var result_write_value = ""
    //현재시간 구하기(년/월/일/초)
    var formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd:HH:mm:ss"
    var current_date_string = formatter.string(from: Date())
    //TEST CODE
    var textLog = createTextFile()
    result_write_value = "** \(current_date_string) **\n\(_writeValue)"
    textLog.write("\(result_write_value)\n\n\n")
}

struct createTextFile:TextOutputStream {
     mutating func write(_ string: String){
         let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
         let documentDirectoryPath = paths.first!
         let log = documentDirectoryPath.appendingPathComponent("my_Custom_Log.txt")
         do{
             let handle = try FileHandle(forWritingTo: log)
             handle.seekToEndOfFile()
             handle.write(string.data(using: .utf8)!)
             handle.closeFile()
         }catch{
             print(error.localizedDescription)
             do{
                 try string.data(using: .utf8)?.write(to: log)
             }catch{
                 print(error.localizedDescription)
             }
         }
     }
 }
