import SwiftUI
import Backend

struct CollectionRowView: View {
    @EnvironmentObject private var collection: UserCollection
    let category: Backend.Category
    
    private var items: [Item] {
        return collection.items
            .filter({ Backend.Category(itemCategory: $0.category) == category })
    }
    
    var body: some View {
        NavigationLink(destination: ItemsView(category: category, items: items)) {
            HStack {
                Image(category.iconName())
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 46, height: 46)
                Text(category.label())
                    .style(appStyle: .rowTitle)
                Spacer()
                Text("\(items.count)")
                    .style(appStyle: .rowDescription)
            }
        }
    }
}
