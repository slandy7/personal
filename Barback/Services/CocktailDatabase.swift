import Foundation

// swiftlint:disable type_body_length file_length
enum CocktailDatabase {
    static let all: [Cocktail] = [
        // ============================================================
        // MARK: - WHISKEY COCKTAILS
        // ============================================================

        Cocktail(
            id: "old-fashioned",
            name: "Old Fashioned",
            ingredients: [
                CocktailIngredient("Bourbon", "2 oz"),
                CocktailIngredient("Simple Syrup", "0.25 oz"),
                CocktailIngredient("Angostura Bitters", "3 dashes"),
                CocktailIngredient("Orange Bitters", "1 dash", isOptional: true),
            ],
            instructions: [
                "Add simple syrup and bitters to a rocks glass.",
                "Add a large ice cube.",
                "Pour bourbon over the ice.",
                "Stir gently for 10-15 seconds.",
                "Express an orange peel over the glass and drop it in.",
            ],
            glass: .rocks,
            garnish: "Orange peel, maraschino cherry",
            category: .whiskey,
            difficulty: .easy,
            description: "The quintessential cocktail. Simple, strong, and timeless — just spirit, sugar, water, and bitters.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "manhattan",
            name: "Manhattan",
            ingredients: [
                CocktailIngredient("Rye Whiskey", "2 oz"),
                CocktailIngredient("Sweet Vermouth", "1 oz"),
                CocktailIngredient("Angostura Bitters", "2 dashes"),
            ],
            instructions: [
                "Combine all ingredients in a mixing glass with ice.",
                "Stir for 30 seconds until well chilled.",
                "Strain into a chilled coupe or Nick & Nora glass.",
                "Garnish with a brandied cherry.",
            ],
            glass: .coupe,
            garnish: "Maraschino cherry",
            category: .whiskey,
            difficulty: .easy,
            description: "A sophisticated, spirit-forward classic from the golden age of cocktails. Equal parts bold and elegant.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "whiskey-sour",
            name: "Whiskey Sour",
            ingredients: [
                CocktailIngredient("Bourbon", "2 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
                CocktailIngredient("Simple Syrup", "0.75 oz"),
                CocktailIngredient("Egg White", "1 oz", isOptional: true),
            ],
            instructions: [
                "If using egg white, dry shake all ingredients vigorously without ice.",
                "Add ice and shake again until well chilled.",
                "Strain into a rocks glass over fresh ice.",
                "Garnish with a cherry and orange half-wheel.",
            ],
            glass: .rocks,
            garnish: "Maraschino cherry, orange slice",
            category: .whiskey,
            difficulty: .easy,
            description: "The perfect balance of sweet, sour, and strong. Add egg white for a luxurious silky texture.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "sazerac",
            name: "Sazerac",
            ingredients: [
                CocktailIngredient("Rye Whiskey", "2 oz"),
                CocktailIngredient("Simple Syrup", "0.25 oz"),
                CocktailIngredient("Peychaud's Bitters", "3 dashes"),
                CocktailIngredient("Absinthe", "rinse"),
            ],
            instructions: [
                "Rinse a chilled rocks glass with absinthe, discarding the excess.",
                "In a mixing glass, combine rye, simple syrup, and bitters with ice.",
                "Stir for 30 seconds until well chilled.",
                "Strain into the absinthe-rinsed glass (no ice).",
                "Express a lemon peel over the surface and discard.",
            ],
            glass: .rocks,
            garnish: "Lemon peel (expressed and discarded)",
            category: .whiskey,
            difficulty: .medium,
            description: "New Orleans' official cocktail. A bold, aromatic rye drink with the mysterious kiss of absinthe.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "mint-julep",
            name: "Mint Julep",
            ingredients: [
                CocktailIngredient("Bourbon", "2.5 oz"),
                CocktailIngredient("Simple Syrup", "0.5 oz"),
                CocktailIngredient("Mint", "8-10 leaves"),
            ],
            instructions: [
                "Gently muddle mint leaves with simple syrup in a julep cup or rocks glass.",
                "Pack the glass tightly with crushed ice.",
                "Pour bourbon over the ice.",
                "Stir briefly and add more crushed ice to form a dome.",
                "Garnish with a generous bouquet of mint.",
            ],
            glass: .rocks,
            garnish: "Mint bouquet",
            category: .whiskey,
            difficulty: .easy,
            description: "The iconic Derby Day sipper. Crushingly refreshing bourbon served over a mountain of crushed ice.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "boulevardier",
            name: "Boulevardier",
            ingredients: [
                CocktailIngredient("Bourbon", "1.5 oz"),
                CocktailIngredient("Sweet Vermouth", "1 oz"),
                CocktailIngredient("Campari", "1 oz"),
            ],
            instructions: [
                "Combine all ingredients in a mixing glass with ice.",
                "Stir for 30 seconds until well chilled.",
                "Strain over a large ice cube in a rocks glass.",
                "Garnish with an orange peel.",
            ],
            glass: .rocks,
            garnish: "Orange peel",
            category: .whiskey,
            difficulty: .easy,
            description: "A Negroni's American cousin. Swapping gin for bourbon adds warmth and depth to the bitter-sweet formula.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "penicillin",
            name: "Penicillin",
            ingredients: [
                CocktailIngredient("Scotch", "2 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
                CocktailIngredient("Honey Syrup", "0.75 oz"),
                CocktailIngredient("Ginger Syrup", "0.25 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a rocks glass over fresh ice.",
                "Optionally float a barspoon of peaty Scotch on top.",
                "Garnish with candied ginger.",
            ],
            glass: .rocks,
            garnish: "Candied ginger",
            category: .whiskey,
            difficulty: .medium,
            description: "A modern classic from Sam Ross. Smoky Scotch meets honey and ginger for the cocktail that cures all.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "paper-plane",
            name: "Paper Plane",
            ingredients: [
                CocktailIngredient("Bourbon", "0.75 oz"),
                CocktailIngredient("Aperol", "0.75 oz"),
                CocktailIngredient("Amaro Nonino", "0.75 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
            ],
            glass: .coupe,
            garnish: "None",
            category: .whiskey,
            difficulty: .easy,
            description: "An equal-parts modern classic. Bitter, sweet, nutty, and bright — perfectly balanced and effortlessly cool.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "vieux-carre",
            name: "Vieux Carré",
            ingredients: [
                CocktailIngredient("Rye Whiskey", "1 oz"),
                CocktailIngredient("Cognac", "1 oz"),
                CocktailIngredient("Sweet Vermouth", "1 oz"),
                CocktailIngredient("Bénédictine", "0.5 oz"),
                CocktailIngredient("Angostura Bitters", "2 dashes"),
                CocktailIngredient("Peychaud's Bitters", "2 dashes"),
            ],
            instructions: [
                "Combine all ingredients in a mixing glass with ice.",
                "Stir for 30 seconds until well chilled.",
                "Strain into a rocks glass over a large ice cube.",
            ],
            glass: .rocks,
            garnish: "Lemon peel",
            category: .whiskey,
            difficulty: .medium,
            description: "A complex New Orleans treasure. Two base spirits and herbal Bénédictine make this a bartender's favorite.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "rob-roy",
            name: "Rob Roy",
            ingredients: [
                CocktailIngredient("Scotch", "2 oz"),
                CocktailIngredient("Sweet Vermouth", "1 oz"),
                CocktailIngredient("Angostura Bitters", "2 dashes"),
            ],
            instructions: [
                "Combine all ingredients in a mixing glass with ice.",
                "Stir for 30 seconds until well chilled.",
                "Strain into a chilled coupe glass.",
                "Garnish with a brandied cherry.",
            ],
            glass: .coupe,
            garnish: "Maraschino cherry",
            category: .whiskey,
            difficulty: .easy,
            description: "A Manhattan made with Scotch. Smoky, herbal, and subtly sweet — a Scottish gentleman's drink.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "rusty-nail",
            name: "Rusty Nail",
            ingredients: [
                CocktailIngredient("Scotch", "1.5 oz"),
                CocktailIngredient("Drambuie", "0.75 oz"),
            ],
            instructions: [
                "Pour both ingredients over a large ice cube in a rocks glass.",
                "Stir gently to combine.",
                "Garnish with a lemon twist.",
            ],
            glass: .rocks,
            garnish: "Lemon twist",
            category: .whiskey,
            difficulty: .easy,
            description: "Just two ingredients, impossibly smooth. Scotch and honeyed Drambuie in perfect harmony.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "godfather",
            name: "Godfather",
            ingredients: [
                CocktailIngredient("Scotch", "1.5 oz"),
                CocktailIngredient("Amaretto", "0.75 oz"),
            ],
            instructions: [
                "Pour both ingredients over a large ice cube in a rocks glass.",
                "Stir gently to combine.",
            ],
            glass: .rocks,
            garnish: "Orange peel",
            category: .whiskey,
            difficulty: .easy,
            description: "Simple and strong. Nutty amaretto softens Scotch into a smooth, after-dinner sipper.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "gold-rush",
            name: "Gold Rush",
            ingredients: [
                CocktailIngredient("Bourbon", "2 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
                CocktailIngredient("Honey Syrup", "0.75 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a rocks glass over fresh ice.",
            ],
            glass: .rocks,
            garnish: "None",
            category: .whiskey,
            difficulty: .easy,
            description: "A Whiskey Sour upgraded with honey syrup. Three ingredients, pure gold.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "new-york-sour",
            name: "New York Sour",
            ingredients: [
                CocktailIngredient("Bourbon", "2 oz"),
                CocktailIngredient("Lemon Juice", "1 oz"),
                CocktailIngredient("Simple Syrup", "0.75 oz"),
                CocktailIngredient("Red Wine", "0.5 oz"),
                CocktailIngredient("Egg White", "1 oz", isOptional: true),
            ],
            instructions: [
                "If using egg white, dry shake all ingredients (except wine) without ice.",
                "Add ice and shake again until well chilled.",
                "Strain into a rocks glass over fresh ice.",
                "Slowly pour red wine over the back of a spoon to create a float.",
            ],
            glass: .rocks,
            garnish: "Red wine float",
            category: .whiskey,
            difficulty: .medium,
            description: "A Whiskey Sour crowned with a dramatic red wine float. Beautiful and delicious.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "irish-coffee",
            name: "Irish Coffee",
            ingredients: [
                CocktailIngredient("Irish Whiskey", "1.5 oz"),
                CocktailIngredient("Espresso", "4 oz"),
                CocktailIngredient("Simple Syrup", "0.5 oz"),
                CocktailIngredient("Heavy Cream", "float"),
            ],
            instructions: [
                "Preheat an Irish coffee glass with hot water, then discard.",
                "Add hot coffee, whiskey, and simple syrup. Stir to combine.",
                "Lightly whip the cream until it just holds shape.",
                "Pour the cream gently over the back of a spoon to float on top.",
                "Do not stir — drink the coffee through the cream.",
            ],
            glass: .irishCoffee,
            garnish: "Floated cream",
            category: .whiskey,
            difficulty: .medium,
            description: "Warming, rich, and comforting. Hot coffee, Irish whiskey, and a blanket of barely-whipped cream.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "hot-toddy",
            name: "Hot Toddy",
            ingredients: [
                CocktailIngredient("Bourbon", "1.5 oz"),
                CocktailIngredient("Honey Syrup", "0.75 oz"),
                CocktailIngredient("Lemon Juice", "0.5 oz"),
                CocktailIngredient("Hot Water", "4 oz"),
            ],
            instructions: [
                "Add bourbon, honey syrup, and lemon juice to a warmed mug.",
                "Top with hot water and stir gently.",
                "Garnish with a lemon wheel and cinnamon stick.",
            ],
            glass: .irishCoffee,
            garnish: "Lemon wheel, cinnamon stick",
            category: .whiskey,
            difficulty: .easy,
            description: "The classic cold-weather cure. Warm, honeyed, and soothing.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "blood-and-sand",
            name: "Blood and Sand",
            ingredients: [
                CocktailIngredient("Scotch", "0.75 oz"),
                CocktailIngredient("Sweet Vermouth", "0.75 oz"),
                CocktailIngredient("Cherry Heering", "0.75 oz"),
                CocktailIngredient("Orange Juice", "0.75 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
                "Garnish with an orange peel.",
            ],
            glass: .coupe,
            garnish: "Orange peel",
            category: .whiskey,
            difficulty: .easy,
            description: "Named after a 1922 Valentino film. An unusual but harmonious blend of Scotch, cherry, and citrus.",
            ibaOfficial: false
        ),

        // ============================================================
        // MARK: - GIN COCKTAILS
        // ============================================================

        Cocktail(
            id: "dry-martini",
            name: "Dry Martini",
            ingredients: [
                CocktailIngredient("Gin", "2.5 oz"),
                CocktailIngredient("Dry Vermouth", "0.5 oz"),
            ],
            instructions: [
                "Combine gin and vermouth in a mixing glass with ice.",
                "Stir for 30 seconds until well chilled.",
                "Strain into a chilled martini or Nick & Nora glass.",
                "Garnish with a lemon twist or olive.",
            ],
            glass: .martini,
            garnish: "Lemon twist or olive",
            category: .gin,
            difficulty: .easy,
            description: "The king of cocktails. Gin and vermouth, stirred cold, served up — nothing more, nothing less.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "negroni",
            name: "Negroni",
            ingredients: [
                CocktailIngredient("Gin", "1 oz"),
                CocktailIngredient("Sweet Vermouth", "1 oz"),
                CocktailIngredient("Campari", "1 oz"),
            ],
            instructions: [
                "Combine all ingredients in a rocks glass over a large ice cube.",
                "Stir for 15-20 seconds to chill and dilute.",
                "Garnish with an orange peel.",
            ],
            glass: .rocks,
            garnish: "Orange peel",
            category: .gin,
            difficulty: .easy,
            description: "Beautifully bitter, perfectly balanced. Three equal parts, infinite satisfaction.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "tom-collins",
            name: "Tom Collins",
            ingredients: [
                CocktailIngredient("Gin", "2 oz"),
                CocktailIngredient("Lemon Juice", "1 oz"),
                CocktailIngredient("Simple Syrup", "0.5 oz"),
                CocktailIngredient("Club Soda", "2 oz"),
            ],
            instructions: [
                "Combine gin, lemon juice, and simple syrup in a shaker with ice.",
                "Shake for 10 seconds.",
                "Strain into a Collins glass filled with ice.",
                "Top with club soda and gently stir.",
                "Garnish with a lemon wheel and cherry.",
            ],
            glass: .collins,
            garnish: "Lemon wheel, maraschino cherry",
            category: .gin,
            difficulty: .easy,
            description: "A tall, refreshing, sparkling lemonade — but with gin. The ultimate summer highball.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "gimlet",
            name: "Gimlet",
            ingredients: [
                CocktailIngredient("Gin", "2.5 oz"),
                CocktailIngredient("Lime Juice", "0.75 oz"),
                CocktailIngredient("Simple Syrup", "0.75 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
                "Garnish with a lime wheel.",
            ],
            glass: .coupe,
            garnish: "Lime wheel",
            category: .gin,
            difficulty: .easy,
            description: "Sharp, clean, and beautifully tart. Gin and lime in their most elegant form.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "french-75",
            name: "French 75",
            ingredients: [
                CocktailIngredient("Gin", "1 oz"),
                CocktailIngredient("Lemon Juice", "0.5 oz"),
                CocktailIngredient("Simple Syrup", "0.5 oz"),
                CocktailIngredient("Champagne", "3 oz"),
            ],
            instructions: [
                "Combine gin, lemon juice, and simple syrup in a shaker with ice.",
                "Shake briefly for 8-10 seconds.",
                "Strain into a champagne flute.",
                "Top with champagne.",
                "Garnish with a lemon twist.",
            ],
            glass: .flute,
            garnish: "Lemon twist",
            category: .gin,
            difficulty: .easy,
            description: "Named after a WWI field gun for its kick. Gin, lemon, and champagne — celebratory and deadly.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "last-word",
            name: "Last Word",
            ingredients: [
                CocktailIngredient("Gin", "0.75 oz"),
                CocktailIngredient("Green Chartreuse", "0.75 oz"),
                CocktailIngredient("Maraschino Liqueur", "0.75 oz"),
                CocktailIngredient("Lime Juice", "0.75 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
            ],
            glass: .coupe,
            garnish: "None",
            category: .gin,
            difficulty: .easy,
            description: "A Prohibition-era equal-parts gem. Herbal, sweet, tart — a perfect quartet of flavors.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "aviation",
            name: "Aviation",
            ingredients: [
                CocktailIngredient("Gin", "2 oz"),
                CocktailIngredient("Maraschino Liqueur", "0.5 oz"),
                CocktailIngredient("Crème de Violette", "0.25 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
                "Garnish with a brandied cherry.",
            ],
            glass: .coupe,
            garnish: "Maraschino cherry",
            category: .gin,
            difficulty: .easy,
            description: "A stunning lavender-hued pre-Prohibition classic. Floral, tart, and as beautiful as a twilight sky.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "bees-knees",
            name: "Bee's Knees",
            ingredients: [
                CocktailIngredient("Gin", "2 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
                CocktailIngredient("Honey Syrup", "0.75 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
                "Garnish with a lemon twist.",
            ],
            glass: .coupe,
            garnish: "Lemon twist",
            category: .gin,
            difficulty: .easy,
            description: "Prohibition-era slang for 'the best.' Honey and lemon make gin sing. And it really is the bee's knees.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "clover-club",
            name: "Clover Club",
            ingredients: [
                CocktailIngredient("Gin", "2 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
                CocktailIngredient("Raspberry Syrup", "0.75 oz"),
                CocktailIngredient("Egg White", "1 oz", isOptional: true),
            ],
            instructions: [
                "If using egg white, dry shake all ingredients without ice first.",
                "Add ice and shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
                "Garnish with fresh raspberries.",
            ],
            glass: .coupe,
            garnish: "Fresh raspberries",
            category: .gin,
            difficulty: .medium,
            description: "A beautiful pink pre-Prohibition classic. Fruity, tart, and silky — named for a Philadelphia gentlemen's club.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "corpse-reviver-2",
            name: "Corpse Reviver #2",
            ingredients: [
                CocktailIngredient("Gin", "0.75 oz"),
                CocktailIngredient("Cointreau", "0.75 oz"),
                CocktailIngredient("Lillet Blanc", "0.75 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
                CocktailIngredient("Absinthe", "1 dash"),
            ],
            instructions: [
                "Rinse a chilled coupe glass with absinthe (or add a dash to the shaker).",
                "Combine remaining ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into the prepared glass.",
            ],
            glass: .coupe,
            garnish: "None",
            category: .gin,
            difficulty: .medium,
            description: "A hangover cure from the 1930s Savoy Hotel. 'Four of these taken in swift succession will un-revive the corpse again.'",
            ibaOfficial: true
        ),

        Cocktail(
            id: "gin-and-tonic",
            name: "Gin & Tonic",
            ingredients: [
                CocktailIngredient("Gin", "2 oz"),
                CocktailIngredient("Tonic Water", "4 oz"),
            ],
            instructions: [
                "Fill a highball glass with ice.",
                "Pour gin over the ice.",
                "Top with tonic water.",
                "Gently stir once to combine.",
                "Garnish with a lime wedge.",
            ],
            glass: .highball,
            garnish: "Lime wedge",
            category: .gin,
            difficulty: .easy,
            description: "The world's simplest great drink. Crisp, bitter, effervescent. Born of the British Empire.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "gin-fizz",
            name: "Gin Fizz",
            ingredients: [
                CocktailIngredient("Gin", "2 oz"),
                CocktailIngredient("Lemon Juice", "1 oz"),
                CocktailIngredient("Simple Syrup", "0.75 oz"),
                CocktailIngredient("Club Soda", "2 oz"),
            ],
            instructions: [
                "Combine gin, lemon juice, and simple syrup in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a highball glass (no ice).",
                "Top with club soda.",
            ],
            glass: .highball,
            garnish: "Lemon wheel",
            category: .gin,
            difficulty: .easy,
            description: "Light, frothy, and refreshing. A fizzy gin lemonade that's perfect any time of day.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "bramble",
            name: "Bramble",
            ingredients: [
                CocktailIngredient("Gin", "2 oz"),
                CocktailIngredient("Lemon Juice", "1 oz"),
                CocktailIngredient("Simple Syrup", "0.5 oz"),
                CocktailIngredient("Crème de Cassis", "0.5 oz"),
            ],
            instructions: [
                "Combine gin, lemon juice, and simple syrup in a shaker with ice.",
                "Shake for 10-12 seconds.",
                "Strain into a rocks glass filled with crushed ice.",
                "Drizzle crème de cassis over the top — let it bleed through the ice.",
            ],
            glass: .rocks,
            garnish: "Blackberry, lemon slice",
            category: .gin,
            difficulty: .easy,
            description: "Dick Bradsell's 1980s masterpiece. A gin sour with a cascade of blackberry liqueur through crushed ice.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "negroni-sbagliato",
            name: "Negroni Sbagliato",
            ingredients: [
                CocktailIngredient("Campari", "1 oz"),
                CocktailIngredient("Sweet Vermouth", "1 oz"),
                CocktailIngredient("Prosecco", "2 oz"),
            ],
            instructions: [
                "Add Campari and sweet vermouth to a rocks glass with ice.",
                "Top with prosecco.",
                "Gently stir once to combine.",
                "Garnish with an orange slice.",
            ],
            glass: .rocks,
            garnish: "Orange slice",
            category: .other,
            difficulty: .easy,
            description: "A 'mistaken' Negroni — prosecco instead of gin. Lighter, bubbly, and utterly addictive.",
            ibaOfficial: false
        ),

        // ============================================================
        // MARK: - RUM COCKTAILS
        // ============================================================

        Cocktail(
            id: "daiquiri",
            name: "Daiquiri",
            ingredients: [
                CocktailIngredient("White Rum", "2 oz"),
                CocktailIngredient("Lime Juice", "1 oz"),
                CocktailIngredient("Simple Syrup", "0.75 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
            ],
            glass: .coupe,
            garnish: "Lime wheel",
            category: .rum,
            difficulty: .easy,
            description: "The bartender's handshake. Three perfect ingredients in exact balance. Nothing frozen about it.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "mojito",
            name: "Mojito",
            ingredients: [
                CocktailIngredient("White Rum", "2 oz"),
                CocktailIngredient("Lime Juice", "1 oz"),
                CocktailIngredient("Simple Syrup", "0.75 oz"),
                CocktailIngredient("Mint", "8-10 leaves"),
                CocktailIngredient("Club Soda", "2 oz"),
            ],
            instructions: [
                "Gently muddle mint leaves in the bottom of a highball glass.",
                "Add rum, lime juice, and simple syrup.",
                "Fill with ice and stir.",
                "Top with club soda and stir gently.",
                "Garnish with a mint sprig and lime wheel.",
            ],
            glass: .highball,
            garnish: "Mint sprig, lime wheel",
            category: .rum,
            difficulty: .easy,
            description: "Havana in a glass. Fresh mint, rum, lime, and bubbles — impossibly refreshing.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "mai-tai",
            name: "Mai Tai",
            ingredients: [
                CocktailIngredient("Aged Rum", "2 oz"),
                CocktailIngredient("Lime Juice", "1 oz"),
                CocktailIngredient("Orange Curaçao", "0.75 oz"),
                CocktailIngredient("Orgeat", "0.5 oz"),
                CocktailIngredient("Simple Syrup", "0.25 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain over crushed ice in a rocks glass.",
                "Garnish with a spent lime half and mint sprig.",
            ],
            glass: .rocks,
            garnish: "Mint sprig, lime shell",
            category: .rum,
            difficulty: .medium,
            description: "Trader Vic's crowning achievement. Rich rum, nutty orgeat, and citrus — the tiki drink to end all tiki drinks.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "dark-n-stormy",
            name: "Dark 'n' Stormy",
            ingredients: [
                CocktailIngredient("Dark Rum", "2 oz"),
                CocktailIngredient("Ginger Beer", "4 oz"),
                CocktailIngredient("Lime Juice", "0.5 oz"),
            ],
            instructions: [
                "Fill a highball glass with ice.",
                "Add lime juice and ginger beer.",
                "Float dark rum on top by pouring over the back of a spoon.",
            ],
            glass: .highball,
            garnish: "Lime wedge",
            category: .rum,
            difficulty: .easy,
            description: "Bermuda's national drink. Dark rum storming over spicy ginger beer — dramatic and delicious.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "pina-colada",
            name: "Piña Colada",
            ingredients: [
                CocktailIngredient("White Rum", "2 oz"),
                CocktailIngredient("Coconut Cream", "1.5 oz"),
                CocktailIngredient("Pineapple Juice", "1.5 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 15 seconds (or blend with ice).",
                "Strain into a hurricane glass or large rocks glass with ice.",
                "Garnish with a pineapple wedge.",
            ],
            glass: .hurricane,
            garnish: "Pineapple wedge, cherry",
            category: .rum,
            difficulty: .easy,
            description: "If you like getting caught in the rain. Creamy coconut and pineapple — pure tropical bliss.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "zombie",
            name: "Zombie",
            ingredients: [
                CocktailIngredient("White Rum", "1.5 oz"),
                CocktailIngredient("Dark Rum", "1.5 oz"),
                CocktailIngredient("Overproof Rum", "1 oz"),
                CocktailIngredient("Lime Juice", "1 oz"),
                CocktailIngredient("Pineapple Juice", "1 oz"),
                CocktailIngredient("Grenadine", "0.5 oz"),
                CocktailIngredient("Angostura Bitters", "2 dashes"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a tiki mug or tall glass filled with crushed ice.",
                "Garnish elaborately with tropical fruits and mint.",
            ],
            glass: .tiki,
            garnish: "Mint sprig, pineapple, cherry",
            category: .rum,
            difficulty: .medium,
            description: "Don the Beachcomber's legendary creation. Three rums and a limit of two per customer. You've been warned.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "hurricane",
            name: "Hurricane",
            ingredients: [
                CocktailIngredient("Dark Rum", "2 oz"),
                CocktailIngredient("Passion Fruit Syrup", "1 oz"),
                CocktailIngredient("Lemon Juice", "1 oz"),
                CocktailIngredient("Orange Juice", "1 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a hurricane glass filled with ice.",
                "Garnish with an orange slice and cherry.",
            ],
            glass: .hurricane,
            garnish: "Orange slice, cherry",
            category: .rum,
            difficulty: .easy,
            description: "Born at Pat O'Brien's in New Orleans. Fruity, potent, and party-ready.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "hemingway-daiquiri",
            name: "Hemingway Daiquiri",
            ingredients: [
                CocktailIngredient("White Rum", "2 oz"),
                CocktailIngredient("Lime Juice", "0.75 oz"),
                CocktailIngredient("Grapefruit Juice", "0.5 oz"),
                CocktailIngredient("Maraschino Liqueur", "0.5 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
                "Garnish with a lime wheel.",
            ],
            glass: .coupe,
            garnish: "Lime wheel",
            category: .rum,
            difficulty: .easy,
            description: "Papa's favorite. A daiquiri made drier and more complex with grapefruit and maraschino. No sugar added.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "jungle-bird",
            name: "Jungle Bird",
            ingredients: [
                CocktailIngredient("Dark Rum", "1.5 oz"),
                CocktailIngredient("Campari", "0.75 oz"),
                CocktailIngredient("Pineapple Juice", "1.5 oz"),
                CocktailIngredient("Lime Juice", "0.5 oz"),
                CocktailIngredient("Simple Syrup", "0.5 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a rocks glass over fresh ice.",
                "Garnish with a pineapple wedge.",
            ],
            glass: .rocks,
            garnish: "Pineapple wedge",
            category: .rum,
            difficulty: .easy,
            description: "A bitter-tropical marvel from 1978 Kuala Lumpur. Campari meets rum and pineapple in unlikely perfection.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "painkiller",
            name: "Painkiller",
            ingredients: [
                CocktailIngredient("Aged Rum", "2 oz"),
                CocktailIngredient("Pineapple Juice", "4 oz"),
                CocktailIngredient("Orange Juice", "1 oz"),
                CocktailIngredient("Coconut Cream", "1 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 15 seconds.",
                "Strain into a rocks glass filled with crushed ice.",
                "Grate fresh nutmeg over the top.",
            ],
            glass: .rocks,
            garnish: "Grated nutmeg",
            category: .rum,
            difficulty: .easy,
            description: "Born at the Soggy Dollar Bar in the BVIs. Creamy, tropical, and strong — swim-up-bar perfection.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "rum-punch",
            name: "Rum Punch",
            ingredients: [
                CocktailIngredient("Dark Rum", "2 oz"),
                CocktailIngredient("Orange Juice", "2 oz"),
                CocktailIngredient("Pineapple Juice", "2 oz"),
                CocktailIngredient("Lime Juice", "1 oz"),
                CocktailIngredient("Grenadine", "0.5 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake for 12-15 seconds.",
                "Strain into a tall glass filled with ice.",
                "Garnish with an orange slice and cherry.",
            ],
            glass: .highball,
            garnish: "Orange slice, cherry",
            category: .rum,
            difficulty: .easy,
            description: "The classic Caribbean party drink. One of sour, two of sweet, three of strong, four of weak.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "caipirinha",
            name: "Caipirinha",
            ingredients: [
                CocktailIngredient("Cachaça", "2 oz"),
                CocktailIngredient("Lime Juice", "1 oz"),
                CocktailIngredient("Sugar", "2 tsp"),
            ],
            instructions: [
                "Cut half a lime into wedges and muddle with sugar in a rocks glass.",
                "Fill with crushed ice.",
                "Pour cachaça over the ice.",
                "Stir briefly to combine.",
            ],
            glass: .rocks,
            garnish: "Lime wedge",
            category: .rum,
            difficulty: .easy,
            description: "Brazil's national cocktail. Muddled lime, sugar, and cachaça — rustic, punchy, and dangerously easy to drink.",
            ibaOfficial: true
        ),

        // ============================================================
        // MARK: - TEQUILA & MEZCAL COCKTAILS
        // ============================================================

        Cocktail(
            id: "margarita",
            name: "Margarita",
            ingredients: [
                CocktailIngredient("Tequila Blanco", "2 oz"),
                CocktailIngredient("Lime Juice", "1 oz"),
                CocktailIngredient("Cointreau", "1 oz"),
            ],
            instructions: [
                "Optionally salt half the rim of a rocks glass.",
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into the prepared glass over fresh ice.",
            ],
            glass: .rocks,
            garnish: "Lime wheel, salt rim",
            category: .tequila,
            difficulty: .easy,
            description: "The world's most popular cocktail. Tart, bright, and agave-forward — perfect on the rocks.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "tommys-margarita",
            name: "Tommy's Margarita",
            ingredients: [
                CocktailIngredient("Tequila Blanco", "2 oz"),
                CocktailIngredient("Lime Juice", "1 oz"),
                CocktailIngredient("Agave Syrup", "0.5 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a rocks glass over fresh ice.",
            ],
            glass: .rocks,
            garnish: "Lime wheel",
            category: .tequila,
            difficulty: .easy,
            description: "Julio Bermejo's San Francisco classic. Agave syrup instead of orange liqueur lets the tequila shine.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "paloma",
            name: "Paloma",
            ingredients: [
                CocktailIngredient("Tequila Blanco", "2 oz"),
                CocktailIngredient("Grapefruit Juice", "3 oz"),
                CocktailIngredient("Lime Juice", "0.5 oz"),
                CocktailIngredient("Simple Syrup", "0.5 oz"),
                CocktailIngredient("Club Soda", "1 oz"),
            ],
            instructions: [
                "Combine tequila, grapefruit juice, lime juice, and syrup in a shaker with ice.",
                "Shake briefly for 8-10 seconds.",
                "Strain into a highball glass filled with ice.",
                "Top with club soda.",
                "Garnish with a grapefruit wedge.",
            ],
            glass: .highball,
            garnish: "Grapefruit wedge, salt rim",
            category: .tequila,
            difficulty: .easy,
            description: "Mexico's favorite tequila drink (not the margarita). Grapefruit, lime, and soda — light and crushable.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "tequila-sunrise",
            name: "Tequila Sunrise",
            ingredients: [
                CocktailIngredient("Tequila Blanco", "2 oz"),
                CocktailIngredient("Orange Juice", "4 oz"),
                CocktailIngredient("Grenadine", "0.5 oz"),
            ],
            instructions: [
                "Fill a highball glass with ice.",
                "Pour tequila and orange juice. Stir gently.",
                "Slowly pour grenadine down the inside of the glass — it will sink and create a sunrise gradient.",
                "Do not stir. Garnish with an orange slice and cherry.",
            ],
            glass: .highball,
            garnish: "Orange slice, cherry",
            category: .tequila,
            difficulty: .easy,
            description: "A 1970s icon. Watch the grenadine sink through orange juice to create a beautiful desert sunrise.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "oaxaca-old-fashioned",
            name: "Oaxaca Old Fashioned",
            ingredients: [
                CocktailIngredient("Tequila Reposado", "1.5 oz"),
                CocktailIngredient("Mezcal", "0.5 oz"),
                CocktailIngredient("Agave Syrup", "0.25 oz"),
                CocktailIngredient("Angostura Bitters", "2 dashes"),
            ],
            instructions: [
                "Combine all ingredients in a mixing glass with ice.",
                "Stir for 20-30 seconds until well chilled.",
                "Strain over a large ice cube in a rocks glass.",
                "Express an orange peel over the glass and use as garnish.",
            ],
            glass: .rocks,
            garnish: "Orange peel",
            category: .tequila,
            difficulty: .easy,
            description: "Phil Ward's Death & Co masterpiece. The Old Fashioned goes to Mexico — smoky, complex, extraordinary.",
            ibaOfficial: false
        ),

        // ============================================================
        // MARK: - VODKA COCKTAILS
        // ============================================================

        Cocktail(
            id: "cosmopolitan",
            name: "Cosmopolitan",
            ingredients: [
                CocktailIngredient("Vodka", "1.5 oz"),
                CocktailIngredient("Cointreau", "1 oz"),
                CocktailIngredient("Lime Juice", "0.5 oz"),
                CocktailIngredient("Cranberry Juice", "1 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled martini glass.",
                "Garnish with a lime wheel.",
            ],
            glass: .martini,
            garnish: "Lime wheel",
            category: .vodka,
            difficulty: .easy,
            description: "The pink drink that conquered the '90s. Tart, citrusy, and unapologetically glamorous.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "moscow-mule",
            name: "Moscow Mule",
            ingredients: [
                CocktailIngredient("Vodka", "2 oz"),
                CocktailIngredient("Ginger Beer", "4 oz"),
                CocktailIngredient("Lime Juice", "0.5 oz"),
            ],
            instructions: [
                "Fill a copper mug (or highball glass) with ice.",
                "Add vodka and lime juice.",
                "Top with ginger beer.",
                "Stir gently and garnish with a lime wheel.",
            ],
            glass: .copperMug,
            garnish: "Lime wheel",
            category: .vodka,
            difficulty: .easy,
            description: "The drink that launched a thousand copper mugs. Spicy ginger beer, vodka, and lime — effervescent bliss.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "espresso-martini",
            name: "Espresso Martini",
            ingredients: [
                CocktailIngredient("Vodka", "2 oz"),
                CocktailIngredient("Coffee Liqueur", "0.5 oz"),
                CocktailIngredient("Espresso", "1 oz"),
                CocktailIngredient("Simple Syrup", "0.25 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake very hard for 15 seconds to build a frothy crema.",
                "Strain into a chilled martini glass.",
                "Garnish with three coffee beans.",
            ],
            glass: .martini,
            garnish: "Three coffee beans",
            category: .vodka,
            difficulty: .medium,
            description: "Dick Bradsell invented it for a model who wanted something to 'wake me up, then mess me up.' Mission accomplished.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "white-russian",
            name: "White Russian",
            ingredients: [
                CocktailIngredient("Vodka", "2 oz"),
                CocktailIngredient("Coffee Liqueur", "1 oz"),
                CocktailIngredient("Heavy Cream", "1 oz"),
            ],
            instructions: [
                "Pour vodka and coffee liqueur over ice in a rocks glass.",
                "Float cream on top by pouring over the back of a spoon.",
                "Stir if desired, or let it cascade.",
            ],
            glass: .rocks,
            garnish: "None",
            category: .vodka,
            difficulty: .easy,
            description: "The Dude abides. Creamy, sweet, caffeinated, and extremely sessionable.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "black-russian",
            name: "Black Russian",
            ingredients: [
                CocktailIngredient("Vodka", "2 oz"),
                CocktailIngredient("Coffee Liqueur", "1 oz"),
            ],
            instructions: [
                "Pour both ingredients over ice in a rocks glass.",
                "Stir to combine.",
            ],
            glass: .rocks,
            garnish: "None",
            category: .vodka,
            difficulty: .easy,
            description: "The White Russian's sleek older sibling. Just vodka and coffee liqueur — dark, bold, and simple.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "bloody-mary",
            name: "Bloody Mary",
            ingredients: [
                CocktailIngredient("Vodka", "2 oz"),
                CocktailIngredient("Tomato Juice", "4 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
                CocktailIngredient("Worcestershire Sauce", "3 dashes"),
                CocktailIngredient("Tabasco", "2 dashes"),
                CocktailIngredient("Salt", "pinch"),
                CocktailIngredient("Pepper", "pinch"),
                CocktailIngredient("Horseradish", "0.5 tsp", isOptional: true),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Roll (pour back and forth) rather than shake to avoid foaming.",
                "Strain into a tall glass filled with ice.",
                "Garnish lavishly — celery stalk, olives, lemon, pickles, bacon — go wild.",
            ],
            glass: .highball,
            garnish: "Celery stalk, lemon wedge, olives",
            category: .vodka,
            difficulty: .medium,
            description: "The ultimate brunch cocktail and hangover remedy. A savory, spicy, umami-rich breakfast in a glass.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "vesper",
            name: "Vesper",
            ingredients: [
                CocktailIngredient("Gin", "3 oz"),
                CocktailIngredient("Vodka", "1 oz"),
                CocktailIngredient("Lillet Blanc", "0.5 oz"),
            ],
            instructions: [
                "Combine all ingredients in a mixing glass with ice.",
                "Stir until very well chilled (or shake, as Bond demands).",
                "Strain into a chilled martini glass.",
                "Garnish with a large, thin lemon peel.",
            ],
            glass: .martini,
            garnish: "Lemon peel",
            category: .gin,
            difficulty: .easy,
            description: "James Bond's personal recipe from Casino Royale. 'I never have more than one drink before dinner. But I do like that one to be large and very strong.'",
            ibaOfficial: true
        ),

        Cocktail(
            id: "lemon-drop",
            name: "Lemon Drop",
            ingredients: [
                CocktailIngredient("Vodka", "2 oz"),
                CocktailIngredient("Lemon Juice", "1 oz"),
                CocktailIngredient("Simple Syrup", "0.75 oz"),
                CocktailIngredient("Cointreau", "0.25 oz"),
            ],
            instructions: [
                "Sugar the rim of a chilled martini glass.",
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into the prepared glass.",
                "Garnish with a lemon wheel.",
            ],
            glass: .martini,
            garnish: "Lemon wheel, sugar rim",
            category: .vodka,
            difficulty: .easy,
            description: "Bright, sweet, and bracingly tart. Liquid lemon candy for grown-ups.",
            ibaOfficial: false
        ),

        // ============================================================
        // MARK: - BRANDY & OTHER COCKTAILS
        // ============================================================

        Cocktail(
            id: "sidecar",
            name: "Sidecar",
            ingredients: [
                CocktailIngredient("Cognac", "2 oz"),
                CocktailIngredient("Cointreau", "0.75 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
            ],
            instructions: [
                "Optionally sugar the rim of a coupe glass.",
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into the prepared glass.",
            ],
            glass: .coupe,
            garnish: "Orange peel, sugar rim",
            category: .brandy,
            difficulty: .easy,
            description: "A Prohibition-era Paris classic. Cognac, citrus, and orange liqueur — the sour template perfected.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "brandy-alexander",
            name: "Brandy Alexander",
            ingredients: [
                CocktailIngredient("Brandy", "1.5 oz"),
                CocktailIngredient("Crème de Cacao", "1 oz"),
                CocktailIngredient("Heavy Cream", "1 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
                "Grate fresh nutmeg on top.",
            ],
            glass: .coupe,
            garnish: "Grated nutmeg",
            category: .brandy,
            difficulty: .easy,
            description: "A dessert in a glass. Creamy, chocolatey, and indulgent — John Lennon's favorite cocktail.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "pisco-sour",
            name: "Pisco Sour",
            ingredients: [
                CocktailIngredient("Pisco", "2 oz"),
                CocktailIngredient("Lime Juice", "1 oz"),
                CocktailIngredient("Simple Syrup", "0.75 oz"),
                CocktailIngredient("Egg White", "1 oz"),
                CocktailIngredient("Angostura Bitters", "3 drops"),
            ],
            instructions: [
                "Dry shake all ingredients (except bitters) vigorously without ice.",
                "Add ice and shake again for 12-15 seconds.",
                "Strain into a rocks glass (no ice).",
                "Drop bitters on top of the foam and drag through with a pick for decoration.",
            ],
            glass: .rocks,
            garnish: "Angostura bitters drops on foam",
            category: .brandy,
            difficulty: .medium,
            description: "Peru and Chile's shared treasure. Pisco, lime, and a pillow of egg white foam — tangy, silky, magnificent.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "amaretto-sour",
            name: "Amaretto Sour",
            ingredients: [
                CocktailIngredient("Amaretto", "1.5 oz"),
                CocktailIngredient("Bourbon", "0.75 oz"),
                CocktailIngredient("Lemon Juice", "1 oz"),
                CocktailIngredient("Simple Syrup", "0.25 oz"),
                CocktailIngredient("Egg White", "1 oz", isOptional: true),
            ],
            instructions: [
                "If using egg white, dry shake all ingredients without ice first.",
                "Add ice and shake vigorously for 12-15 seconds.",
                "Strain into a rocks glass over fresh ice.",
                "Garnish with a cherry and lemon peel.",
            ],
            glass: .rocks,
            garnish: "Maraschino cherry, lemon peel",
            category: .other,
            difficulty: .easy,
            description: "The Jeffrey Morgenthaler recipe that redeemed a much-maligned drink. Bourbon adds backbone, egg white adds luxury.",
            ibaOfficial: false
        ),

        Cocktail(
            id: "aperol-spritz",
            name: "Aperol Spritz",
            ingredients: [
                CocktailIngredient("Aperol", "2 oz"),
                CocktailIngredient("Prosecco", "3 oz"),
                CocktailIngredient("Club Soda", "1 oz"),
            ],
            instructions: [
                "Fill a large wine glass with ice.",
                "Add Aperol, then prosecco.",
                "Top with a splash of club soda.",
                "Stir gently and garnish with an orange slice.",
            ],
            glass: .wineGlass,
            garnish: "Orange slice",
            category: .other,
            difficulty: .easy,
            description: "The official drink of golden hour. Bittersweet, bubbly, low-ABV, and Instagram-ready.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "grasshopper",
            name: "Grasshopper",
            ingredients: [
                CocktailIngredient("Crème de Menthe", "1 oz"),
                CocktailIngredient("Crème de Cacao", "1 oz"),
                CocktailIngredient("Heavy Cream", "1 oz"),
            ],
            instructions: [
                "Combine all ingredients in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a chilled coupe glass.",
            ],
            glass: .coupe,
            garnish: "Grated chocolate",
            category: .other,
            difficulty: .easy,
            description: "Mint-chocolate-chip ice cream in cocktail form. Sweet, creamy, and unashamedly retro.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "long-island-iced-tea",
            name: "Long Island Iced Tea",
            ingredients: [
                CocktailIngredient("Vodka", "0.5 oz"),
                CocktailIngredient("Gin", "0.5 oz"),
                CocktailIngredient("White Rum", "0.5 oz"),
                CocktailIngredient("Tequila Blanco", "0.5 oz"),
                CocktailIngredient("Cointreau", "0.5 oz"),
                CocktailIngredient("Lemon Juice", "0.75 oz"),
                CocktailIngredient("Simple Syrup", "0.25 oz"),
                CocktailIngredient("Cola", "2 oz"),
            ],
            instructions: [
                "Combine all spirits, lemon juice, and simple syrup in a shaker with ice.",
                "Shake briefly for 8-10 seconds.",
                "Strain into a Collins glass filled with ice.",
                "Top with cola.",
                "Garnish with a lemon wedge.",
            ],
            glass: .collins,
            garnish: "Lemon wedge",
            category: .other,
            difficulty: .easy,
            description: "Five spirits that somehow taste like iced tea. Famously potent, deceptively smooth.",
            ibaOfficial: true
        ),

        Cocktail(
            id: "singapore-sling",
            name: "Singapore Sling",
            ingredients: [
                CocktailIngredient("Gin", "1.5 oz"),
                CocktailIngredient("Cherry Heering", "0.5 oz"),
                CocktailIngredient("Cointreau", "0.25 oz"),
                CocktailIngredient("Bénédictine", "0.25 oz"),
                CocktailIngredient("Lime Juice", "0.5 oz"),
                CocktailIngredient("Grenadine", "0.25 oz"),
                CocktailIngredient("Angostura Bitters", "1 dash"),
                CocktailIngredient("Pineapple Juice", "4 oz"),
                CocktailIngredient("Club Soda", "1 oz"),
            ],
            instructions: [
                "Combine all ingredients except club soda in a shaker with ice.",
                "Shake vigorously for 12-15 seconds.",
                "Strain into a Collins glass filled with ice.",
                "Top with club soda.",
                "Garnish with a pineapple slice and cherry.",
            ],
            glass: .collins,
            garnish: "Pineapple slice, cherry",
            category: .gin,
            difficulty: .advanced,
            description: "A legendary creation from the Raffles Hotel, 1915. Complex, fruity, and worth tracking down every ingredient.",
            ibaOfficial: true
        ),
    ]

    // MARK: - Lookup Helpers

    static let byId: [String: Cocktail] = {
        Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
    }()

    static let byCategory: [CocktailCategory: [Cocktail]] = {
        Dictionary(grouping: all, by: { $0.category })
    }()

    static let count: Int = all.count

    static func search(_ query: String) -> [Cocktail] {
        guard !query.isEmpty else { return all }
        let lowered = query.lowercased()
        return all.filter { cocktail in
            cocktail.name.lowercased().contains(lowered) ||
            cocktail.ingredients.contains { $0.name.lowercased().contains(lowered) } ||
            cocktail.category.rawValue.lowercased().contains(lowered) ||
            cocktail.description.lowercased().contains(lowered)
        }
    }
}
// swiftlint:enable type_body_length file_length
