import Cocoa

enum TransactionType: String, Codable {
    case domestic
    case international
}

protocol SmartContract: Codable {
    func appy(transaction: Transaction)
}

class TransactionTypeSmartContract: SmartContract, Equatable, Codable, Hashable {
    func appy(transaction: Transaction) {
        var fees = 0.0

        switch transaction.transactionType {
            case .domestic:
                fees = 0.02
            default:
                fees = 0.05
        }

        transaction.fee = transaction.amount * fees
        transaction.amount -= transaction.fee
    }

    static func == (lhs: TransactionTypeSmartContract, rhs: TransactionTypeSmartContract) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

class Transaction: Hashable, Codable {

    var from: String
    var to: String
    var amount: Double
    var transactionType: TransactionType
    var fee: Double = 0.0
    var name: String

    init(name: String, from: String, to: String, amount: Double, transactionType: TransactionType) {
        self.from = from
        self.to = to
        self.amount = amount
        self.transactionType = transactionType
        self.name = name
    }

    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

}

class Block: Hashable, Codable {

    var index = 0
    var previousHash = ""
    var hash: String!
    var nonce: Int

    private var transactions: Set<Transaction> = []
    var key: String {
        get {
            let transactionData = try! JSONEncoder().encode(self.transactions)
            let transactionString = String(data: transactionData, encoding: .utf8)

            return String(self.index) + self.previousHash + String(self.nonce) + transactionString!
        }
    }

    init() {
        self.nonce = 0
    }

    func addTransaction(transaction: Transaction) {
        transactions.insert(transaction)
    }

    static func == (lhs: Block, rhs: Block) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

class BlockChain: Codable {
    private var blocks: Array<Block> = []
    private var smartContracts: Set<TransactionTypeSmartContract> = [TransactionTypeSmartContract()]
    init(genesisBlock: Block) {

        if blocks.isEmpty {
            addBlock(genesisBlock)
        }
    }

    private enum CodingKeys: CodingKey {
        case blocks
    }

    func addBlock(_ block: Block) {
        if blocks.isEmpty {
            block.previousHash = "00000000000000"
            block.hash = generateHash(for: block)
        }

        blocks.append(block)
    }

    func getNextBlock(transactions: [Transaction]) -> Block {
        let block = Block()

        transactions.forEach {
            block.addTransaction(transaction: $0)
        }

        let previousBlock = getPreviousBlock()
        block.index = blocks.count
        block.previousHash = previousBlock.hash
        block.hash = generateHash(for: block)

        return block
    }

    func getPreviousBlock() -> Block {
        guard let block = blocks.last else { return Block() }
        return block
    }

    func generateHash(for block: Block) -> String {
        var hash: String {
            get {
                var h = block.key.toSha1Hash()
                while !h.hasPrefix("00") {
                    block.nonce += 1
                    h = block.key.toSha1Hash()

                    print(h)
                }
                return h
            }
        }
        return hash
    }

}

extension String {

    func toSha1Hash() -> String {

        let task = Process()
        task.launchPath = "/usr/bin/shasum"
        task.arguments = []

        let inputPipe = Pipe()

        inputPipe.fileHandleForWriting.write(self.data(using: String.Encoding.utf8)!)

        inputPipe.fileHandleForWriting.closeFile()

        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardInput = inputPipe
        task.launch()

        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let hash = String(data: data, encoding: String.Encoding.utf8)!
        return hash.replacingOccurrences(of: "  -\n", with: "")
    }
}

let genesisBlock = Block()
let blockChain = BlockChain(genesisBlock: genesisBlock)

let transaction01 = Transaction(name:"Crypto Debt 01", from: "Mary", to: "Steve", amount: 20, transactionType: .domestic)
let transaction02 = Transaction(name:"Chain payment - 08/15", from: "Joe", to: "Mary", amount: 35, transactionType: .international)
print("---------------------------------------")
let block = blockChain.getNextBlock(transactions: [transaction01, transaction02])
blockChain.addBlock(block)

let data = try! JSONEncoder().encode(blockChain)
let jsonData = String(data: data, encoding: .utf8)
print(jsonData!)
