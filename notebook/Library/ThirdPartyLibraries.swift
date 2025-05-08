// Adicionando libs externas usando o Cocoapods
// Vamos instalar e usas essa lib: https://github.com/Alamofire/Alamofire
// Instale o cocopod pelo terminal:
//      $ sudo gem install cocoapods
//      $ pod setup --verbose
// Instale todas as dependencias que o cocoapods pedir, caso precise
// Ao finalizar a instação vamos confirmar que ta tudo certo com o comando:
//      $ pod --version
// Va até o diretorio onde o arquivo .xcodeproj do seu projeto está e
// execute o comando para criar o Podfile:
//      $ pod init
// Faça a integração do CPF-CNPJ-Validator no cocopod a partir do arquivo Podfile
//      pod 'Alamofire'
// Rode o comando:
//      $ pod install
// Agora saia da sessão que vc estas do xcode e utilize o .xcworkspace para abrir uma nova sessão.
// Para saber se a lib é compativel com seu PodFile olhe o arquivo .podspec do github deles, olhe
// a versão e a platform que é compativel
// Com isso vamos poder usar a lib
import Alamofire

func thirdPartyLibraryRunner() async {
    let response = await AF.request("https://httpbin.org/get")
        .serializingData()
        .response
    
    print("Ola mundo!")
    debugPrint(response)
}


