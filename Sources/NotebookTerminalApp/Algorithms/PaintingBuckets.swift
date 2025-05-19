// Algoritmo para calcular a quantidade de latas de tinta suficiente para cobrir uma parede.

import Foundation
import AppKit
import ArgumentParser

struct PaintingBucketsCommands: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "painting-bucket",
        abstract: "Calcula a quantidade de latas de tinta para pintar uma parede."
    )

    @OptionGroup var common: CommonOptions

    @Option(
        name: .shortAndLong,  // -w --width
        help: "Largura da parede"
    )
    var width: Float

    @Option(
        name: .shortAndLong,  // -h --height
        help: "Altura da parede"
    )
    var height: Float

    @Option(
        name: [.customShort("a"), .customLong("bucketAreaCovered")],  // -a --bucketAreaCovered
        help: "Area coberta por uma lata de tinta"
    )
    var bucketAreaCovered: Float

    func run() throws {
        paintingBucketRunner(width, height, bucketAreaCovered)
    }
}

func paintingBucketRunner(_ width: Float, _ height: Float, _ bucketAreaCovered: Float) {
    var bucketsOfPaint: Int {
        let area = width * height
        let numberOfBuckets = area / bucketAreaCovered
        let roundedBuckets = ceilf(numberOfBuckets)
        return Int(roundedBuckets)
    }

    print("Precisaremos de \(bucketsOfPaint) latas de tinta para cobrir a parede.")
    let areaCanCover = Float(bucketsOfPaint) * bucketAreaCovered
    print("Essa quantidade de tinta pode cobrir uma area de \(areaCanCover)m2")
}
