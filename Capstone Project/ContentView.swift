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
}

// MARK: - Sample Data
// Basic list of clinics to show in the app

let sampleClinics: [Clinic] = [
    Clinic(name: "CommunityHealth – Lederman Family Health Center",
           neighborhood: "West Town",
           address: "2611 W. Chicago Ave, Chicago, IL 60622",
           phone: "773-395-9900",
           services: ["Primary Care", "Dental", "Mental Health"],
           payment: "Free",
           latitude: 41.8957, longitude: -87.6862),

    Clinic(name: "Howard Brown Health – Halsted",
           neighborhood: "Lakeview",
           address: "3501 N. Halsted St, Chicago, IL 60657",
           phone: "773-388-1600",
           services: ["Primary Care", "LGBTQ+ Care", "Dental"],
           payment: "Low Cost",
           latitude: 41.9445, longitude: -87.6491),

    Clinic(name: "Erie Family Health Centers – West Town",
           neighborhood: "West Town",
           address: "1701 W. Superior St, Chicago, IL 60622",
           phone: "312-666-3494",
           services: ["Primary Care", "Women's Health", "Pediatrics"],
           payment: "Low Cost",
           latitude: 41.8949, longitude: -87.6721)
]

// MARK: - Main Content View
// This is the app's starting point. It shows 3 tabs at the bottom.

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            MapView()
                .tabItem { Label("Map", systemImage: "map.fill") }

            ClinicListView()
                .tabItem { Label("Clinics", systemImage: "list.bullet") }
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
            span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
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
            HStack {
                ForEach(clinic.services, id: \.self) { service in
                    Text(service)
                        .font(.caption)
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }

            Spacer()
        }
        .padding()
    }
}

// MARK: - Preview
// Lets you see the app in Xcode's preview pane

#Preview {
    ContentView()
}
