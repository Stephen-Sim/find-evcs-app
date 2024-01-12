import 'package:find_evcs/blocs/review_station/review_station_bloc.dart';
import 'package:find_evcs/models/station.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewStationPage extends StatefulWidget {
  final Station station;
  const ReviewStationPage({super.key, required this.station});

  @override
  State<ReviewStationPage> createState() => _ReviewStationPageState();
}

class _ReviewStationPageState extends State<ReviewStationPage> {
  @override
  void initState() {
    super.initState();

    context
        .read<ReviewStationBloc>()
        .add(GetReviewsEvent(stationId: widget.station.id!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Review - ${widget.station.name}'),
            backgroundColor: Color.fromARGB(255, 168, 144, 238)),
        backgroundColor: Color.fromRGBO(203, 195, 227, 1),
        body: BlocListener<ReviewStationBloc, ReviewStationState>(
          listener: (context, state) {
            if (state is ReviewStaionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is ReviewStaionSuccess) {
              Navigator.pop(context, true);
            }
          },
          child: BlocBuilder<ReviewStationBloc, ReviewStationState>(
            builder: (context, state) {
              if (state is ReviewStationLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ReviewStationLoaded) {
                return Column(children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.reviews.length,
                      itemBuilder: (context, index) {
                        final station = state.reviews[index];
                        return Card(
                          color: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.black),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.person, color: Colors.purple),
                            title: Text(
                              "${station.guestName.length > 20 ? station.guestName.substring(0, 17) + '...' : station.guestName} (${station.rating}⭐)",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${station.description.length > 60 ? station.description.substring(0, 57) + '...' : station.description}",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ReviewInput(),
                  SizedBox(
                    height: 40,
                  )
                ]);
              } else if (state is ReviewStaionIsNull) {
                return ReviewInput();
              } else {
                return ReviewInput();
              }
            },
          ),
        ));
  }

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  int rating = 5;

  Widget ReviewInput() {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const Text(
              "Review Detail:",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              controller: _nameController,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              controller: _descController,
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Rating:",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                this.rating = rating.toInt();
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 400.0,
                height: 55.0,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ReviewStationBloc>().add(
                        CreateReviewButtonPressed(
                            stationId: widget.station.id!,
                            description: _descController.text,
                            guestName: _nameController.text,
                            rating: rating));
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    )),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 168, 144, 238)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Review',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
