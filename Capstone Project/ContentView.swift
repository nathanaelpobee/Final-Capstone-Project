import SwiftUI
import MapKit

// MARK: - Data Model
// This describes what one clinic looks like

struct Clinic: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let neighborhood: String
    let address: String
    let phone: String
    let services: [String]
    let payment: String // "Free" or "Low Cost"
    let latitude: Double
    let longitude: Double

    var offersMentalHealth: Bool {
        services.contains("Mental Health")
    }
}

// MARK: - Sample Data
// All 14 verified Chicago clinics

let sampleClinics: [Clinic] = [
    Clinic(name: "CommunityHealth – Lederman Family Health Center",
           neighborhood: "West Town",
           address: "2611 W. Chicago Ave, Chicago, IL 60622",
           phone: "773-395-9900",
           services: ["Primary Care", "Specialty Care", "Lab Services", "Telehealth", "Mental Health", "Dental"],
           payment: "Free",
           latitude: 41.8957, longitude: -87.6862),

    Clinic(name: "Howard Brown Health – Halsted",
           neighborhood: "Lakeview",
           address: "3501 N. Halsted St, Chicago, IL 60657",
           phone: "773-388-1600",
           services: ["Primary Care", "LGBTQ+ Care", "Mental Health", "Dental", "Vision", "HIV/AIDS Care"],
           payment: "Low Cost",
           latitude: 41.9445, longitude: -87.6491),

    Clinic(name: "Chicago Family Health Center – South Chicago HC",
           neighborhood: "South Chicago",
           address: "9119 S. Exchange Ave, Chicago, IL 60617",
           phone: "773-768-5000",
           services: ["Primary Care", "Pediatrics", "Women's Health", "Mental Health", "Dental"],
           payment: "Low Cost",
           latitude: 41.7295, longitude: -87.5495),

    Clinic(name: "Care for Friends",
           neighborhood: "Lincoln Park",
           address: "530 W. Fullerton Pkwy, Chicago, IL 60614",
           phone: "773-932-1010",
           services: ["Podiatry"],
           payment: "Free",
           latitude: 41.9256, longitude: -87.6390),

    Clinic(name: "Chicago Women's Health Center",
           neighborhood: "Uptown",
           address: "1025 W. Sunnyside Ave, #201, Chicago, IL 60640",
           phone: "773-935-6126",
           services: ["Primary Care", "Women's Health", "HIV/STI Testing", "Mental Health"],
           payment: "Low Cost",
           latitude: 41.9633, longitude: -87.6584),

    Clinic(name: "Norma Jean Sanders Free Clinic",
           neighborhood: "Kenwood",
           address: "1049 E. 46th St, Chicago, IL 60653",
           phone: "773-624-8987",
           services: ["Primary Care", "Immunizations", "Vision Care", "HIV/STI Testing"],
           payment: "Free",
           latitude: 41.8121, longitude: -87.6042),

    Clinic(name: "Old Irving Park Community Clinic",
           neighborhood: "Portage Park",
           address: "5425 W. Addison St, Chicago, IL 60641",
           phone: "773-427-0298",
           services: ["Chronic Disease Management", "Women's Health", "STI Testing", "Mental Health"],
           payment: "Free",
           latitude: 41.9464, longitude: -87.7648),

    Clinic(name: "Erie Family Health Centers – West Town",
           neighborhood: "West Town",
           address: "1701 W. Superior St, Chicago, IL 60622",
           phone: "312-666-3494",
           services: ["Primary Care", "Women's Health", "Pediatrics", "Mental Health"],
           payment: "Low Cost",
           latitude: 41.8949, longitude: -87.6721),

    Clinic(name: "Lawndale Christian Health Center – Main",
           neighborhood: "North Lawndale",
           address: "3860 W. Ogden Ave, Chicago, IL 60623",
           phone: "872-588-3000",
           services: ["Primary Care", "Pediatrics", "Women's Health", "Mental Health", "Dental", "Vision"],
           payment: "Low Cost",
           latitude: 41.8571, longitude: -87.7218),

    Clinic(name: "Near North Health Service – Winfield Moody HC",
           neighborhood: "Near North",
           address: "1276 N. Clybourn Ave, Chicago, IL 60610",
           phone: "312-337-1073",
           services: ["Primary Care", "Dental", "Pediatrics", "Women's Health", "Mental Health", "HIV Testing", "Podiatry", "Vision"],
           payment: "Low Cost",
           latitude: 41.9078, longitude: -87.6435),

    Clinic(name: "ACCESS – Ashland Family Health Center",
           neighborhood: "Englewood",
           address: "5159 S. Ashland Ave, Chicago, IL 60609",
           phone: "773-434-9216",
           services: ["Family Medicine", "Pediatrics", "Women's Health", "Mental Health", "Psychiatry", "Cardiology"],
           payment: "Low Cost",
           latitude: 41.8017, longitude: -87.6656),

    Clinic(name: "PCC Community Wellness – Austin Family Health",
           neighborhood: "Austin",
           address: "5461 W. Lake St, Chicago, IL 60644",
           phone: "773-378-3347",
           services: ["Urgent Care", "Primary Care", "Mental Health"],
           payment: "Low Cost",
           latitude: 41.8871, longitude: -87.7654),

    Clinic(name: "Mile Square Health Center – Main",
           neighborhood: "Near West Side / University Village",
           address: "1220 S. Wood St, Chicago, IL 60608",
           phone: "312-996-2000",
           services: ["Family Medicine", "Pediatrics", "Women's Health", "Mental Health", "HIV/AIDS Care", "Urgent Care"],
           payment: "Low Cost",
           latitude: 41.8663, longitude: -87.6717),

    Clinic(name: "Mile Square Health Center – Back of the Yards",
           neighborhood: "Back of the Yards",
           address: "4630 S. Bishop St, Chicago, IL 60609",
           phone: "312-996-2000",
           services: ["Primary Care", "Dental", "Pediatrics", "Mental Health", "Family Planning", "Prenatal Care"],
           payment: "Low Cost",
           latitude: 41.8085, longitude: -87.6664)
]

// MARK: - Main Content View
// This is the app's starting point. It now shows 4 tabs at the bottom.

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            MapView()
                .tabItem { Label("Map", systemImage: "map.fill") }

            ClinicListView()
                .tabItem { Label("Clinics", systemImage: "list.bullet") }

            MentalHealthView()
                .tabItem { Label("Mental Health", systemImage: "brain.head.profile") }
        }
    }
}

// MARK: - Home Screen
// First tab, matches the "Find Free Healthcare Near You" mockup

struct HomeView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack {
                        Text("Find Free Healthcare")
                        Text("Near You").foregroundColor(.teal)
                    }
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                    Text("Search free and charitable clinics throughout Chicago.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search by ZIP, neighborhood, or service", text: $searchText)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                    NavigationLink(destination: MapView()) {
                        Label("View Interactive Map", systemImage: "map")
                    }
                    .buttonStyle(.bordered)

                    HStack {
                        FilterPill(text: "Primary Care")
                        FilterPill(text: "Dental")
                        FilterPill(text: "Mental Health")
                    }
                }
                .padding()
            }
            .navigationTitle("Chicago CareFinder")
        }
    }
}

// Small reusable pill/tag view used on the home screen
struct FilterPill: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(Color.teal.opacity(0.15))
            .cornerRadius(20)
    }
}

// MARK: - Map Screen
// Second tab, shows clinic pins on a map

struct MapView: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298),
            span: MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)
        )
    )
    @State private var selectedClinic: Clinic?

    var body: some View {
        Map(position: $position, selection: $selectedClinic) {
            ForEach(sampleClinics) { clinic in
                Marker(clinic.name,
                       coordinate: CLLocationCoordinate2D(latitude: clinic.latitude, longitude: clinic.longitude))
                    .tag(clinic)
                    .tint(clinic.payment == "Free" ? .green : .blue)
            }
        }
        .sheet(item: $selectedClinic) { clinic in
            ClinicDetailView(clinic: clinic)
                .presentationDetents([.medium])
        }
        .navigationTitle("Interactive Map")
    }
}

// MARK: - Clinic List Screen
// Third tab, shows all clinics as a scrollable list

struct ClinicListView: View {
    var body: some View {
        NavigationStack {
            List(sampleClinics) { clinic in
                NavigationLink(destination: ClinicDetailView(clinic: clinic)) {
                    VStack(alignment: .leading) {
                        Text(clinic.name).font(.headline)
                        Text(clinic.neighborhood)
                            .font(.subheadline).foregroundColor(.secondary)
                        Text(clinic.payment)
                            .font(.caption)
                            .foregroundColor(clinic.payment == "Free" ? .green : .blue)
                    }
                }
            }
            .navigationTitle("Clinic Database")
        }
    }
}

// MARK: - Clinic Detail Screen
// Popup card shown when you tap a clinic on the map or in the list

struct ClinicDetailView: View {
    let clinic: Clinic

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(clinic.name).font(.title2.bold())

                Label(clinic.address, systemImage: "mappin.and.ellipse")
                Label(clinic.phone, systemImage: "phone.fill")

                Text(clinic.payment)
                    .font(.caption)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(clinic.payment == "Free" ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
                    .cornerRadius(20)

                Text("Services").font(.headline).padding(.top, 8)

                // Using a wrapping layout so long service lists don't run off screen
                FlowLayout(items: clinic.services)

                Spacer()
            }
            .padding()
        }
    }
}

// Simple wrapping row of service tags, since some clinics have 6+ services
struct FlowLayout: View {
    let items: [String]

    var body: some View {
        var currentRowWidth: CGFloat = 0
        let screenWidth: CGFloat = 340

        return VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(stride(from: 0, to: items.count, by: 3)), id: \.self) { start in
                HStack {
                    ForEach(items[start..<min(start + 3, items.count)], id: \.self) { service in
                        Text(service)
                            .font(.caption)
                            .padding(.horizontal, 10).padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .onAppear { currentRowWidth = screenWidth } // keeps the compiler happy, no real effect
    }
}

// MARK: - Mental Health Screen
// Fourth tab — crisis resources plus clinics that offer mental health services

struct MentalHealthView: View {
    var mentalHealthClinics: [Clinic] {
        sampleClinics.filter { $0.offersMentalHealth }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("If you're in crisis")
                            .font(.headline)

                        Label("Call or text 988 — Suicide & Crisis Lifeline", systemImage: "phone.fill")
                        Label("Text HOME to 741741 — Crisis Text Line", systemImage: "message.fill")
                        Label("Call 833-626-4244 — NAMI Chicago Helpline", systemImage: "person.fill.questionmark")

                        Text("NAMI Chicago Helpline hours: Mon–Fri 9am–8pm, Sat–Sun 9am–5pm")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Crisis Resources")
                }

                Section {
                    ForEach(mentalHealthClinics) { clinic in
                        NavigationLink(destination: ClinicDetailView(clinic: clinic)) {
                            VStack(alignment: .leading) {
                                Text(clinic.name).font(.headline)
                                Text(clinic.neighborhood)
                                    .font(.subheadline).foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Clinics Offering Mental Health Services")
                }
            }
            .navigationTitle("Mental Health")
        }
    }
}

// MARK: - Preview
// Lets you see the app in Xcode's preview pane

#Preview {
    ContentView()
}
