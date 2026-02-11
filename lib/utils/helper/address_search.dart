// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:snap_task/constants/urls.dart';
// import 'package:snap_task/utils/helper/search_places.dart';
// import 'package:snap_task/utils/theme/apptheme.dart';
//
// class AddressSearch extends SearchPlaceDelegate<Suggestion?> {
//   AddressSearch(this.sessionToken, {this.topTitle}) {
//     apiClient = PlaceApiProvider(sessionToken);
//   }
//
//   final String? sessionToken;
//   final String? topTitle;
//
//   late PlaceApiProvider apiClient;
//
//   @override
//   String get title {
//     if (topTitle != null) {
//       return topTitle!;
//     } else {
//       return "Search Location";
//     }
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return suggestionsResults(context);
//   }
//
//   FutureBuilder<List<Suggestion>> suggestionsResults(BuildContext context) {
//     return FutureBuilder(
//       future: query == "" || query.length < 3
//           ? null
//           : apiClient.fetchSuggestions(
//               query, Localizations.localeOf(context).languageCode),
//       builder: (context, snapshot) {
//         /// ALREADY COMMENTED
//         /// if (snapshot.hasData) {
//         ///   List<Suggestion>? suggestion = snapshot.data;
//         /// }
//         return query == ''
//             ? const SizedBox()
//             : query.length < 3
//                 ? Align(
//                     alignment: Alignment.topCenter,
//                     child: Text(
//                       'kindly enter min 3 letters to search.',
//                       style: theme.textTheme.bodyMedium,
//                     ),
//                   )
//                 : snapshot.hasData
//                     ? Column(
//                         children: [
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting)
//                             const LinearProgressIndicator(minHeight: 2),
//                           Expanded(
//                             child: Container(
//                               margin: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   color: Colors.grey.shade50),
//                               child: ListView.separated(
//                                 separatorBuilder: (context, index) =>
//                                     const Divider(
//                                   thickness: 0.2,
//                                 ),
//                                 itemBuilder: (context, index) =>
//                                     GestureDetector(
//                                   onTap: () =>
//                                       close(context, snapshot.data![index]),
//                                   child: Container(
//                                     color: Colors.transparent,
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Icon(
//                                           Icons.place_outlined,
//                                           color: appColors.primaryColor,
//                                         ),
//                                         const SizedBox(width: 4),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 (snapshot.data![index])
//                                                         .mainText ??
//                                                     "",
//                                                 style: theme.textTheme.bodyMedium!
//                                                     .copyWith(
//                                                         fontWeight:
//                                                             FontWeight.w700,
//                                                         color: appColors
//                                                             .primaryColor),
//                                               ),
//
//                                               /// ALREADY COMMENTED
//                                               /// AppText.bodySmallBold(
//                                               ///   (snapshot.data![index]).mainText ?? "",
//                                               ///   weight: FontWeight.w600,
//                                               /// ),
//                                               Text(
//                                                 (snapshot.data![index])
//                                                         .secondaryText ??
//                                                     "",
//                                                 style:
//                                                 theme.textTheme.bodyMedium!,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 itemCount: snapshot.data!.length,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : const Align(
//                         alignment: Alignment.topCenter,
//                         child: LinearProgressIndicator(minHeight: 2),
//                       );
//       },
//     );
//   }
// }
//
// class PlaceApiProvider {
//   final client = Client();
//
//   PlaceApiProvider(this.sessionToken);
//
//   final String? sessionToken;
//
//   final String apiKey = URLs.googleAPIKEY;
//
//   Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
//     final request =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=$lang&key=$apiKey&sessiontoken=$sessionToken';
//     final response = await client.get(Uri.parse(request));
//
//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       if (result['status'] == 'OK') {
//         /// ALREADY COMMENTED
//         /// compose suggestions in a list
//         return result['predictions']
//             .map<Suggestion>((p) => Suggestion(
//                   placeId: p['place_id'],
//                   description: p['description'],
//                   mainText: p['structured_formatting']['main_text'],
//                   secondaryText: p['structured_formatting']['secondary_text'],
//                 ))
//             .toList();
//       }
//       if (result['status'] == 'ZERO_RESULTS') {
//         return [];
//       }
//       throw Exception(result['error_message']);
//     } else {
//       throw Exception('Failed to fetch suggestion');
//     }
//   }
//
//   Future<Place?> getPlaceDetailFromId(String? placeId) async {
//     final request =
//         'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component,formatted_address,name,geometry&key=$apiKey&sessiontoken=$sessionToken';
//     final response = await client.get(Uri.parse(request));
//
//     if (response.statusCode == 200) {
//       final result = json.decode(response.body);
//       if (result['status'] == 'OK') {
//         /// ALREADY COMMENTED
//         /// final components = result['result']['address_components'] as List<dynamic>;
//         final place = Place();
//
//         place.shortName = result['result']['name'];
//         place.longName = result['result']['formatted_address'];
//         place.lat = result['result']['geometry']['location']['lat'];
//         place.lng = result['result']['geometry']['location']['lng'];
//
//         /// ALREADY COMMENTED
//         /// for (var c in components) {
//         ///   final List type = c['types'];
//         ///   if (type.contains('street_number')) {
//         ///     place.shortName = c['long_name'];
//         ///   }
//         /// }
//         return place;
//       }
//       throw Exception(result['error_message']);
//     } else {
//       throw Exception('Failed to fetch suggestion');
//     }
//   }
// }
//
// // For storing our result
// class Suggestion {
//   final String? placeId;
//   final String? description;
//   final String? mainText;
//   final String? secondaryText;
//
//   Suggestion({
//     this.placeId,
//     this.description,
//     this.mainText,
//     this.secondaryText,
//   });
//
//   @override
//   String toString() {
//     return 'Suggestion(description: $description, placeId: $placeId)';
//   }
// }
//
// class Place {
//   String? shortName;
//   String? longName;
//   double? lat;
//   double? lng;
//
//   Place({
//     this.shortName,
//     this.longName,
//     this.lat,
//     this.lng,
//   });
//
//   @override
//   String toString() {
//     return 'Place(streetNumber: $shortName, street: $longName, latitude: $lat, longitude: $lng)';
//   }
// }
