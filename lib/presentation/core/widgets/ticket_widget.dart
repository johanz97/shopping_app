import 'package:flutter/material.dart';

import '../../../domain/ticket/ticket.dart';
import '../../pages/ticket/tickets_archive/widgets/ticket_details_modal.dart';
import 'clip_shadow.dart';

class TicketWidget extends StatelessWidget {
  const TicketWidget({
    Key? key,
    required this.body,
    required this.botom,
    this.dashedBottom = false,
    this.details,
    this.isFirst = false,
  }) : super(key: key);

  final bool dashedBottom;
  final bool isFirst;
  final Widget body;
  final Widget botom;
  final Ticket? details;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => details != null
          ? showModalBottomSheet(
              context: context,
              isDismissible: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return TicketDetailsModal(ticket: details!);
              },
            )
          : null,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 350,
            minWidth: 300,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipShadow(
                clipper: _TicketClipper(
                  const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  const BorderRadius.all(Radius.circular(20.0)),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4.0),
                    blurRadius: 2.0,
                    spreadRadius: 2.0,
                    color: isFirst
                        ? Theme.of(context).primaryColor
                        : Colors.grey.withOpacity(0.3),
                  )
                ],
                child: body,
              ),
              ClipShadow(
                clipper: _TicketClipper(
                  const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  const BorderRadius.all(Radius.circular(20.0)),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4.0),
                    blurRadius: 2.0,
                    spreadRadius: 2.0,
                    color: isFirst
                        ? Theme.of(context).primaryColor.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.3),
                  )
                ],
                child: botom,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TicketClipper extends CustomClipper<Path> {
  _TicketClipper(this.innerRadius, this.outerRadius);

  final BorderRadius innerRadius;

  final BorderRadius outerRadius;

  @override
  Path getClip(Size size) {
    /// approximation to a circular arc
    const C = 0.551915024494;
    final path = Path();
    const radiusZero = Radius.zero;

    var currentUseInner = false;
    var currentRadius = radiusZero;

    currentUseInner = innerRadius.topLeft != radiusZero;
    currentRadius = currentUseInner ? innerRadius.topLeft : outerRadius.topLeft;
    path.moveTo(0.0, currentRadius.y);
    path.cubicTo(
      currentUseInner ? currentRadius.x * C : 0.0,
      currentUseInner ? currentRadius.y : currentRadius.y * (1 - C),
      currentUseInner ? currentRadius.x : currentRadius.x * (1 - C),
      currentUseInner ? currentRadius.y * C : 0.0,
      currentRadius.x,
      0.0,
    );

    currentUseInner = innerRadius.topRight != radiusZero;
    currentRadius =
        currentUseInner ? innerRadius.topRight : outerRadius.topRight;
    path.lineTo(size.width - currentRadius.x, 0.0);
    path.cubicTo(
      currentUseInner
          ? size.width - currentRadius.x
          : size.width - currentRadius.x * (1 - C),
      currentUseInner ? currentRadius.y * C : 0.0,
      currentUseInner ? size.width - currentRadius.x * C : size.width,
      currentUseInner ? currentRadius.y : currentRadius.y * (1 - C),
      size.width,
      currentRadius.y,
    );

    currentUseInner = innerRadius.bottomRight != radiusZero;
    currentRadius =
        currentUseInner ? innerRadius.bottomRight : outerRadius.bottomRight;
    path.lineTo(size.width, size.height - currentRadius.y);
    path.cubicTo(
      currentUseInner ? size.width - currentRadius.x * C : size.width,
      currentUseInner
          ? size.height - currentRadius.y
          : size.height - currentRadius.y * (1 - C),
      currentUseInner
          ? size.width - currentRadius.x
          : size.width - currentRadius.x * (1 - C),
      currentUseInner ? size.height - currentRadius.y * C : size.height,
      size.width - currentRadius.x,
      size.height,
    );

    currentUseInner = innerRadius.bottomLeft != radiusZero;
    currentRadius =
        currentUseInner ? innerRadius.bottomLeft : outerRadius.bottomLeft;
    path.lineTo(currentRadius.x, size.height);
    path.cubicTo(
      currentUseInner ? currentRadius.x : currentRadius.x * (1 - C),
      currentUseInner ? size.height - currentRadius.y * C : size.height,
      currentUseInner ? currentRadius.x * C : 0.0,
      currentUseInner
          ? size.height - currentRadius.y
          : size.height - currentRadius.y * (1 - C),
      0.0,
      size.height - currentRadius.y,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
