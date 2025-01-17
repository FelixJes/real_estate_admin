import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_admin/Model/Result.dart';
import 'package:real_estate_admin/Modules/Project/propertyController.dart';

import '../../Model/Project.dart';
import '../../Model/Property.dart';
import '../../widgets/formfield.dart';
import '../../widgets/future_dialog.dart';
import 'property_form_data.dart';
import 'package:badges/badges.dart';

class PropertyForm extends StatefulWidget {
  const PropertyForm({Key? key, this.property, required this.project}) : super(key: key);

  final Project project;
  final Property? property;

  @override
  State<PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  Widget getComissionTile({required final Commission comission, required String title}) {
    final TextEditingController controller = TextEditingController();
    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListTile(
              title: Text(title),
              subtitle: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  comission.value = double.tryParse(text) ?? comission.value;
                  print(comission.value);
                },
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: ListTile(
              title: const Text('In Amount'),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Radio<ComissionType>(
                  value: ComissionType.amount,
                  groupValue: comission.comissionType,
                  onChanged: (val) {
                    setState(() {
                      comission.comissionType = val ?? comission.comissionType;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: ListTile(
              title: const Text("In Percent"),
              subtitle: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Radio<ComissionType>(
                  value: ComissionType.percent,
                  groupValue: comission.comissionType,
                  onChanged: (val) {
                    setState(() {
                      comission.comissionType = val ?? comission.comissionType;
                    });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getCoverImage(PropertyViewModel data) {
    if (data.coverPhototData != null) {
      return Stack(
        children: [
          Positioned.fill(
            child: Image.memory(
              data.coverPhototData!,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
                color: Colors.black.withOpacity(0.1),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                )),
          ),
        ],
      );
    }
    if ((data.coverPhoto ?? '').isNotEmpty) {
      return Image.network(data.coverPhoto!);
    }
    return GestureDetector(
      onTap: () {
        data.pickCoverPhoto();
      },
      child: Center(
        child: Icon(
          Icons.add_a_photo,
          size: 100,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }

  List<Widget> getPhotoTiles(PropertyViewModel data) {
    List<Widget> images = [];
    var tiles = data.getPhotoTiles();
    images.addAll(tiles
        .map((e) => Card(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image(image: e.provider, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(child: CircleAvatar(child: IconButton(onPressed: e.remove, icon: const Icon(Icons.close)))),
                ],
              ),
            ))
        .toList());
    images.add(
      Card(
        child: AspectRatio(
          aspectRatio: 1,
          child: IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: data.pickImages,
          ),
        ),
      ),
    );

    return images;
  }

  late PropertyViewModel model;

  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      model = PropertyViewModel.fromProperty(widget.property!);
    } else {
      model = PropertyViewModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => model,
      child: Consumer<PropertyViewModel>(builder: (context, data, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Property'),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(child: AspectRatio(aspectRatio: 16 / 9, child: getCoverImage(data))),
                ),
                TileFormField(controller: data.title, title: "Title"),
                Row(
                  children: [
                    Expanded(
                        child: TileFormField(
                      controller: data.plotNumber,
                      title: 'Plot Number',
                    )),
                    Expanded(
                        child: TileFormField(
                      controller: data.surveyNumber,
                      title: 'Survey / Patta Number',
                    ))
                  ],
                ),
                TileFormField(controller: data.dtcpNumber, title: 'DTLP Number'),
                Row(
                  children: [
                    Expanded(
                      child: TileFormField(controller: data.district, title: 'District'),
                    ),
                    Expanded(
                      child: TileFormField(
                        controller: data.taluk,
                        title: 'Taluk',
                      ),
                    )
                  ],
                ),
                TileFormField(
                  controller: data.features,
                  title: 'Features',
                  maxLines: 8,
                ),
                TileFormField(
                  controller: data.description,
                  title: 'Description',
                  maxLines: 8,
                ),
                TileFormField(
                  controller: data.propertyAmount,
                  title: 'Property Value',
                  keyboardType: TextInputType.number,
                ),
                const Divider(),
                ListTile(
                  title: const Text("Supporting Documents"),
                  subtitle: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        height: 130,
                        child: Row(
                          children: getPhotoTiles(data),
                        ),
                      ),
                    ),
                  ),
                ),
                // ListTile(
                //   title: const Text("Comission Details"),
                //   subtitle: SizedBox(height: 60, child: getComissionTile(comission: data.staffComission, title: 'Staff commission')),
                // ),
                // getComissionTile(comission: data.staffComission, title: 'Staff comission'),
                // getComissionTile(comission: data.staffComission, title: 'Staff Commission'),
                Container(
                  height: 60,
                  width: double.maxFinite,
                  margin: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      var propertyController = PropertyController(propertyFormData: data, project: widget.project);
                      Future<Result> future;
                      if (widget.property != null) {
                        future = propertyController.updateProperty();
                      } else {
                        future = propertyController.addProperty();
                      }
                      showFutureDialog(context, future: future);
                    },
                    child: const Text("SAVE PROPERTY"),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
