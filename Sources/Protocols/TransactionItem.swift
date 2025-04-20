import UIKit

/// A model representing a transaction message.
public protocol TransactionItem {
	/// The currencyIcon of Transaction
  var currencyIcon: UIImage { get }

  /// The amount of Transaction
  var amount: String { get }

  /// The chainID of Transaction
  var chainId: String { get }

  /// The txhash of Transaction
  var txHash: String { get }
}
