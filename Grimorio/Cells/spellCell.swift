import UIKit

class SpellCell: UITableViewCell {
    
    var isMultiline: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
        }

    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .raisenBlack
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var valueText: UITextView = {
        let field = UITextView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.systemFont(ofSize: 17.0)
        field.backgroundColor = .raisenBlack
        field.textColor = .mintCream
        field.isEditable = false
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 5
        field.textContainer.lineBreakMode = .byWordWrapping
        field.textContainerInset = UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10)
        return field
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueText])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 5
        stack.backgroundColor = .redSalsa
        self.addSubview(stack)
        return stack
    }()

    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 5
        self.layer.backgroundColor = UIColor.redSalsa.cgColor
        self.layer.borderColor = UIColor.redSalsa.cgColor
    }
    func set(_ data: (String, String), isMultiline: Bool = false) {
        titleLabel.text = data.0
        valueText.text = data.1
        self.isMultiline = isMultiline
    }

}
extension SpellCell {
    private func setupUI() {
        NSLayoutConstraint.activate([
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: stack.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            valueText.leadingAnchor.constraint(equalTo: stack.leadingAnchor)
        ])

        if isMultiline {
            valueText.heightAnchor.constraint(equalToConstant: 180).isActive = true
            valueText.textContainer.maximumNumberOfLines = 0
        } else {
            valueText.heightAnchor.constraint(equalToConstant: 30).isActive = true
            valueText.textContainer.maximumNumberOfLines = 1
        }

    }
}
