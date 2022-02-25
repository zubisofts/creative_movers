import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/data/remote/model/get_connects_response.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_stack/image_stack.dart';

enum AcceptState{idle,loading,succes,failed}
enum DeclineState{idle,loading,succes,failed}
class RequestItem extends StatefulWidget {
  const RequestItem({Key? key, required this.connection}) : super(key: key);
  final Connection connection;

  @override
  _RequestItemState createState() => _RequestItemState();
}

class _RequestItemState extends State<RequestItem> {

  ConnectsBloc _connectsBloc = ConnectsBloc();
  AcceptState acceptState = AcceptState.idle;
  DeclineState declineState = DeclineState.idle;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectsBloc, ConnectsState>(
      bloc: _connectsBloc,
      listener: (context, state) {
        listenToRequestReactState(context, state);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 30,
                foregroundColor: Colors.red,
                backgroundImage:
                    NetworkImage(widget.connection.profilePhotoPath),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.connection.firstname +
                      ' ' +
                      widget.connection.lastname,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                Text(
                  widget.connection.username,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        height: 35,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextButton(
                          onPressed: acceptState == AcceptState.idle ? () {
                            setState(() {
                              acceptState = AcceptState.loading;
                            });
                            _connectsBloc.add(RequestReactEvent(
                                widget.connection.id.toString(), 'accept'));
                          }:null,
                          child:  acceptState == AcceptState.idle ?  const Text(
                            'Accept',
                            style:
                            TextStyle(color: Colors.green, fontSize: 12),
                          ):SizedBox(child: const CircularProgressIndicator(color:Colors.green ,strokeWidth: 2,),height: 10,width: 10,),
                          style: TextButton.styleFrom(

                              padding: EdgeInsets.zero,
                              backgroundColor: AppColors.lightGreen),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextButton(
                          onPressed: declineState == DeclineState.idle ? () {
                            setState(() {
                              declineState = DeclineState.loading;
                            });
                            _connectsBloc.add(RequestReactEvent(
                                widget.connection.id.toString(), 'decline')

                            );
                          }:null,
                          child: declineState == DeclineState.idle ?  const Text(
                            'Decline',
                            style:
                                TextStyle(color: AppColors.red, fontSize: 12),
                          ):Container(child: CircularProgressIndicator(color: AppColors.red,strokeWidth: 2,),height: 10,width: 10,),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: AppColors.lightred),
                        )),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void listenToRequestReactState(BuildContext context, ConnectsState state) {
    if (state is RequestReactLoadingState) {

    }
    if (state is RequestReactSuccesState) {
      setState(() {
        acceptState = AcceptState.succes;
        declineState = DeclineState.succes;
        AppUtils.showCustomToast('Accepted');
      });
    }
    if (state is RequestReactFailureState) {
      setState(() {
        AppUtils.showCustomToast(state.error);

        acceptState = AcceptState.idle;
        declineState = DeclineState.idle;
      });
    }

  }
}
