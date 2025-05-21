/**
 Este guia mostra como realizar operações básicas de I/O de arquivos e diretórios em Swift,
 usando as APIs do Foundation
 
 Abaixo está uma tabela com todas as combinações de bits de permissão (leitura, escrita e execução) e o
 seu valor POSIX em octal, para um único “triplete” (usuário, grupo ou outros):
 
 |Símbolo | Leitura (r) | Escrita (w) | Execução (x) | Valor octal| |
 |-----------|---------------|-----------------|------------------|-----------------|
 |   ---       | 0               | 0                 | 0                   | 0                 |
 |   --x       | 0               | 0                 | 1                   | 1                 |
 |   -w-      | 0               | 1                 | 0                   | 2                 |
 |   -wx     | 0               | 1                 |  1                  | 3                 |
 |   r--       | 1               | 0                 | 0                   | 4                 |
 |   r-x       | 1               | 0                 | 1                   | 5                 |
 |   rw-      | 1               | 1                 | 0                   | 6                 |
 |   rwx      | 1               | 1                 | 1                   | 7                 |

 Como montar uma permissão completa:
 Para um arquivo, você combina três desses valores (usuário, grupo e outros). Por exemplo:
 644 → usuário rw- (6), grupo r-- (4), outros r-- (4) ⇒ -rw-r--r--
 755 → usuário rwx (7), grupo r-x (5), outros r-x (5) ⇒ -rwxr-xr-x
 700 → usuário rwx (7), grupo --- (0), outros --- (0) ⇒ -rwx------
 
 Basta concatenar os três dígitos octais para definir as permissões completas de um arquivo ou diretório.
*/

import Foundation
import AppKit
import ArgumentParser

struct IOCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "io",
        abstract: "Tutorial sobre I/O de arquivos e diretorios em swift"
    )

    @OptionGroup var common: CommonOptions

    func run() throws {
        print("→ Manipulando arquivos:")
        ManipulandoArquivos.run()
    }
}

fileprivate struct Pessoa: Codable {
    let nome: String
    let idade: Int
}

/// Usaremos FileHandle e as funções de conveniência de Data.
fileprivate struct ManipulandoArquivos {
    static func run() {
        do {
            guard let docsURL = FileManager.default
                    .urls(for: .documentDirectory, in: .userDomainMask)
                    .first
            else {
                fatalError("Não consegui localizar a pasta Documentos do usuário")
            }

            let url = docsURL.appendingPathComponent("static", isDirectory: true)
            var path = "."
            if #available(macOS 13.0, *) {
                path = url.relativePath
                print(path) // /Users/<user>/Documents/static
            }

            let folder = "\(path)/folder"
            try createFolder(at: folder)
            // Pasta criada com sucesso!
            print(getFullPath(by: folder))
            // /Users/<user>/Documents/static/folder

            let txtFile = "\(folder)/teste.txt"
            try createFile(at: txtFile)
            // Arquivo criado com sucesso!
            print(try readTXT(at: txtFile))
            // Olá, Mundo!
            try readWithFileHandler(at: txtFile)
            // Olá, Mundo!
            try changePermission(at: txtFile, permissoes: 0o755)
            // Permissões modificadas com sucesso!
            try deleteFile(at: txtFile)
            // Arquivo removido com sucesso!

            let jsonfile = "\(folder)/teste.json"
            try createFile(at: jsonfile)
            // Arquivo criado com sucesso!
            print(try readJSON(at: jsonfile, type: Pessoa.self))
            // PessoaAleatoria(nome: "Ana", idade: 30)
            try deleteFile(at: jsonfile)
            // Arquivo removido com sucesso!

            let plistFile = "\(folder)/teste.plist"
            try createFile(at: plistFile)
            // Arquivo criado com sucesso!
            print(try readPLIST(at: plistFile, type: Pessoa.self))
            // PessoaAleatoria(nome: "Ana", idade: 30)
            try deleteFile(at: plistFile)
            // Arquivo removido com sucesso!

            let csvFile = "\(folder)/teste.csv"
            try createFile(at: csvFile)
            // Arquivo criado com sucesso!
            if #available(macOS 13.0, *) {
                print(try readCSV(at: csvFile))
                // [["nome", "idade"], ["João", "25"]]
            }
            try deleteFile(at: csvFile)
            // Arquivo removido com sucesso!

            try changePermission(at: folder, permissoes: 0o755)
            // Permissões modificadas com sucesso!
            readPermissions(by: folder)
            // Permissões POSIX (octal): 0o755
            try deleteFolder(at: folder)
            // Pasta removida com sucesso! (folder)
            try deleteFolder(at: url.path)
            // Pasta removida com sucesso! (static)
        } catch {
            fatalError("Error: \(error)")
        }
    }

    static func fileExist(at path: String) -> (exist: Bool, isFolder: Bool) {
        var isFolder: ObjCBool = false
        let exist = FileManager.default.fileExists(atPath: path, isDirectory: &isFolder)
        return (exist, isFolder.boolValue)
    }

    static func getFullPath(by path: String) -> String {
        let url = URL(fileURLWithPath: path)
        return url.absoluteURL.path
    }

    static func isExecutable(at path: String) -> Bool {
        let fileManager = FileManager.default
        if fileManager.isExecutableFile(atPath: path) {
            return true
        }
        return false
    }

    static func readPermissions(by path: String) {
        let fileManager = FileManager.default

        do {
            let attrs = try fileManager.attributesOfItem(atPath: path)
            if let permissions = attrs[.posixPermissions] as? NSNumber {
                // permissions é um número decimal, por exemplo 420 para 0o644
                let permOctal = String(format: "%o", permissions.uint16Value)
                print("Permissões POSIX (octal): 0o\(permOctal)")
            } else {
                print("Não foi possível ler as permissões POSIX.")
            }
        } catch {
            print("Erro ao obter atributos do arquivo: \(error)")
        }
    }

    static func readTXT(at path: String) throws -> String {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        guard let content = String(data: data, encoding: .utf8) else {
            throw NSError(
                domain: "LeituraErro",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Codificação inválida"
                ]
            )
        }
        return content
    }

    static func readJSON<T: Decodable>(at path: String, type: T.Type) throws -> T {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    static func readPLIST<T: Decodable>(at path: String, type: T.Type) throws -> T {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        return try decoder.decode(T.self, from: data)
    }

    @available(macOS 13.0, *)
    static func readCSV(at path: String, delimiter: String = ",") throws -> [[String]] {
        let text = try ManipulandoArquivos.readTXT(at: path)
        return text
            .split(separator: "\n")
            .map { $0.split(separator: delimiter).map(String.init) }
    }

    static func readWithFileHandler(at path: String) throws {
        let url = URL(fileURLWithPath: path)
        let fileHandle = try FileHandle(forReadingFrom: url)
        // O `defer` garante o fechamento mesmo em caso de erro.
        defer {
            try? fileHandle.close()
        }

        let data = fileHandle.readDataToEndOfFile()
        if let text = String(data: data, encoding: .utf8) {
            print(text)
        }
    }

    static func createFile(at path: String) throws {
        let fileManager = FileManager.default
        let msg: String? = "Olá, Mundo!"
        let content = msg!.data(using: .utf8)

        let result = fileExist(at: path)
        if result.exist {
            print("Arquivo \(path) já existe.")
            return
        }

        if path.hasSuffix(".txt") {
            let url = URL(fileURLWithPath: path)
            fileManager.createFile(atPath: url.path, contents: content, attributes: nil)
        } else if path.hasSuffix(".json") {
            let _: JSONEncoder = JSONEncoder()
            let person = Pessoa(nome: "Ana", idade: 30)
            let jsonData = try JSONEncoder().encode(person)
            let url = URL(fileURLWithPath: path)
            try jsonData.write(to: url)
        } else if path.hasSuffix(".plist") {
            let person = Pessoa(nome: "Ana", idade: 30)
            let plistData = try PropertyListEncoder().encode(person)
            let url = URL(fileURLWithPath: path)
            try plistData.write(to: url)
        } else if path.hasSuffix(".csv") {
            let lines = ["nome,idade", "João,25"]
            let csvData = lines.joined(separator: "\n").data(using: .utf8)!
            let url = URL(fileURLWithPath: path)
            try csvData.write(to: url)
        } else {
            fatalError("Extensão não registrada para o arquivo \(path).")
        }

        print("Arquivo criado com sucesso!")
    }

    static func deleteFile(at path: String) throws {
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: path)
        try fileManager.removeItem(at: url)
        print("Arquivo removido com sucesso!")
    }

    static func createFolder(at path: String) throws {
        let fileManager = FileManager.default
        let result = fileExist(at: path)
        if !result.exist {
            try fileManager.createDirectory(
                atPath: path,
                withIntermediateDirectories: true,
                attributes: nil
            )
            print("Pasta criada com sucesso!")
        } else {
            print("Pasta \(path) já existe.")
        }
    }

    static func deleteFolder(at path: String) throws {
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: path)
        try fileManager.removeItem(at: url)
        print("Pasta removida com sucesso!")
    }

    static func changePermission(at path: String, permissoes: Int) throws {
        // permissoes no estilo UNIX, e.g. 0o755
        let attrs: [FileAttributeKey: Any] = [.posixPermissions: permissoes]
        let fileManager = FileManager.default
        try fileManager.setAttributes(attrs, ofItemAtPath: path)
        print("Permissões modificadas com sucesso!")
    }
}
