import 'package:app_position/features/routine/presentation/routine_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});
  static const String route = '/about';

  @override
  Widget build(BuildContext context) {
    final settings = context.read<RoutineRepository>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Somos un grupo de desarrolladores que buscan lograr su titulo universitario mediante esta aplicación móvil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.3125,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Acerca de la aplicación',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fecha de modificación:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    '14/02/2024',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nombre de versión:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    settings.versionName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Código de versión:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    settings.versionCode,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Min. versión:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    '34',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // const Text(
              //   'Colaboradores',
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Column(
              //         children: [
              //           ClipRRect(
              //             borderRadius: BorderRadius.circular(16),
              //             child: Image.asset('assets/image/collaborators/diego_yangua.jpg'),
              //           ),
              //           const SizedBox(height: 8),
              //           const Text(
              //             'Diego Yangua',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.normal,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     const SizedBox(width: 16),
              //     Expanded(
              //       child: Column(
              //         children: [
              //           ClipRRect(
              //             borderRadius: BorderRadius.circular(16),
              //             child: Image.asset('assets/image/collaborators/olga_zapata.jpg'),
              //           ),
              //           const SizedBox(height: 8),
              //           const Text(
              //             'Olga Zapata',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.normal,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 16),
              const Text(
                'Agradecimientos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Agradezco a todas aquellas personas que apoyaron directa o indirectamente al conocimiento necesario para la realización de este proyecto, así como a mi nuestras bebes: Oso, Tini, Michulita, Fruna y Naranjo que nos dieron el cariño suficiente para terminar este proyecto ❤',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              // const SizedBox(height: 16),
              // const Text(
              //   'Apoyo externo',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Column(
              //         children: [
              //           ClipRRect(
              //             borderRadius: BorderRadius.circular(16),
              //             child: Image.asset(
              //               'assets/image/logos/ucv.png',
              //               height: 100,
              //             ),
              //           ),
              //           const SizedBox(height: 8),
              //           const Text(
              //             'Universidad Cesar Vallejo',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.normal,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     const SizedBox(width: 16),
              //     Expanded(
              //       child: Column(
              //         children: [
              //           ClipRRect(
              //             borderRadius: BorderRadius.circular(16),
              //             child: Image.asset(
              //               'assets/image/logos/fractal.png',
              //               height: 100,
              //             ),
              //           ),
              //           const SizedBox(height: 8),
              //           const Text(
              //             'FRACTAL',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               fontSize: 16,
              //               fontWeight: FontWeight.normal,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
