import 'dart:convert';

import 'package:find_evcs/blocs/station/create/create_station_bloc.dart';
import 'package:find_evcs/pages/station/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateStationPage extends StatefulWidget {
  const CreateStationPage({Key? key}) : super(key: key);

  @override
  State<CreateStationPage> createState() => _CreateStationPageState();
}

class _CreateStationPageState extends State<CreateStationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _totalStationsController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  double? lat;
  double? long;

  final ImagePicker _picker = ImagePicker();
  String? _base64Image;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      setState(() {
        _base64Image = base64Image;
      });
      Navigator.pop(context);
    }
  }

  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      setState(() {
        _base64Image = base64Image;
      });
      Navigator.pop(context);
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Pick from gallery'),
                  onTap: _pickImage),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo'),
                onTap: _takePhoto,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New EV Station'),
        backgroundColor: Color.fromARGB(255, 168, 144, 238),
      ),
      backgroundColor: Color.fromRGBO(203, 195, 227, 1),
      body: BlocListener<CreateStationBloc, CreateStationState>(
        listener: (context, state) {
          if (state is CreateStaionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }

          if (state is CreateStaionSuccess) {
            Navigator.pop(context, true);
          }
        },
        child: BlocBuilder<CreateStationBloc, CreateStationState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () => _showImageSourceActionSheet(context),
                        child: Container(
                          height: 200,
                          width: 200,
                          color: Colors.grey[200],
                          child: _base64Image == null
                              ? Center(child: Text('Pick an image'))
                              : Image.memory(base64Decode(_base64Image!)),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    TextField(
                      controller: _totalStationsController,
                      decoration: InputDecoration(
                        labelText: 'Total Charging Stations',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: _addressController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add_location),
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapPage()))
                                .then((value) {
                              if (value != null) {
                                lat = value['lat'];
                                long = value['lng'];
                                _addressController.text = value['address'];
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 400.0,
                        height: 55.0,
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<CreateStationBloc>(context).add(
                              CreateStationButtonPressed(
                                name: _nameController.text.isEmpty ? null : _nameController.text,
                                address: _addressController.text.isEmpty ? null : _addressController.text,
                                image: _base64Image,
                                latitude: lat,
                                longitude: long,
                                totalChargingStations: (_totalStationsController.text.isEmpty ? null : int.parse(_totalStationsController.text))
                              ),
                            );
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 168, 144, 238)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Create',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
