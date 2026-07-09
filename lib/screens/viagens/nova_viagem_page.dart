import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/viagem.dart';
import '../repositories/viagem_repository.dart';
import '../repositories/cliente_repository.dart';
import '../repositories/motorista_repository.dart';
import '../repositories/caminhao_repository.dart';
import '../models/cliente.dart';
import '../models/motorista.dart';
import '../models/caminhao.dart';

class NovaViagemPage extends StatefulWidget {
  const NovaViagemPage({super.key});

  @override
  State<NovaViagemPage> createState() => _NovaViagemPageState();
}

class _NovaViagemPageState extends State<NovaViagemPage> {
  final _formKey = GlobalKey<FormState>();
  final viagemRepository = ViagemRepository();
  final clienteRepository = ClienteRepository();
  final motoristaRepository = MotoristRepository();
  final caminhaoRepository = CaminhaoRepository();

  List<Cliente> clientes = [];
  List<Motorista> motoristas = [];
  List<Caminhao> caminhoes = [];

  Cliente? clienteSelecionado;
  Motorista? motoristaSelecionado;
  Caminhao? caminhaoSelecionado;

  final origemController = TextEditingController();
  final destinoController = TextEditingController();

  DateTime dataSaida = DateTime.now();
  DateTime? dataChegada;

  final kmInicialController = TextEditingController();
  final kmFinalController = TextEditingController();

  final litrosDieselController = TextEditingController();
  final valorLitroDieselController = TextEditingController();

  final litrosArlaController = TextEditingController();
  final valorLitroArlaController = TextEditingController();

  final pedagiosController = TextEditingController();
  final alimentacaoController = TextEditingController();
  final hospedagemController = TextEditingController();
  final outrasDespesasController = TextEditingController();

  final valorFreteController = TextEditingController();

  // Valores calculados
  double distancia = 0;
  double custoDiesel = 0;
  double custoArla = 0;
  double custoTotal = 0;
  double custoPorKm = 0;
  double mediaKmLitro = 0;
  double lucroLiquido = 0;
  double margemLucro = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    setState(() => isLoading = true);
    try {
      final clientesCarregados = await clienteRepository.listar();
      final motoristasCarregados = await motoristaRepository.listar();
      final camihoesCarregados = await caminhaoRepository.listar();

      setState(() {
        clientes = clientesCarregados;
        motoristas = motoristasCarregados;
        caminhoes = camihoesCarregados;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void calcular() {
    final kmInicial = double.tryParse(kmInicialController.text) ?? 0;
    final kmFinal = double.tryParse(kmFinalController.text) ?? 0;

    final litrosDiesel = double.tryParse(litrosDieselController.text) ?? 0;
    final valorLitroDiesel =
        double.tryParse(valorLitroDieselController.text) ?? 0;

    final litrosArla = double.tryParse(litrosArlaController.text) ?? 0;
    final valorLitroArla = double.tryParse(valorLitroArlaController.text) ?? 0;

    final pedagios = double.tryParse(pedagiosController.text) ?? 0;
    final alimentacao = double.tryParse(alimentacaoController.text) ?? 0;
    final hospedagem = double.tryParse(hospedagemController.text) ?? 0;
    final outrasDespesas = double.tryParse(outrasDespesasController.text) ?? 0;

    final valorFrete = double.tryParse(valorFreteController.text) ?? 0;

    setState(() {
      distancia = kmFinal - kmInicial;
      custoDiesel = litrosDiesel * valorLitroDiesel;
      custoArla = litrosArla * valorLitroArla;
      custoTotal = custoDiesel + custoArla + pedagios + alimentacao + hospedagem + outrasDespesas;
      custoPorKm = distancia <= 0 ? 0 : custoTotal / distancia;
      mediaKmLitro = litrosDiesel <= 0 ? 0 : distancia / litrosDiesel;
      lucroLiquido = valorFrete - custoTotal;
      margemLucro = valorFrete <= 0 ? 0 : (lucroLiquido / valorFrete) * 100;
    });
  }

  Future<void> salvarViagem() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios')),
      );
      return;
    }

    if (clienteSelecionado == null ||
        motoristaSelecionado == null ||
        caminhaoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Selecione cliente, motorista e caminhão')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final viagem = Viagem(
        clienteId: clienteSelecionado!.id!,
        motoristaId: motoristaSelecionado!.id!,
        caminhaoId: caminhaoSelecionado!.id!,
        origem: origemController.text,
        destino: destinoController.text,
        dataSaida: dataSaida,
        dataChegada: dataChegada,
        kmInicial: double.parse(kmInicialController.text),
        kmFinal: double.parse(kmFinalController.text),
        litrosDiesel: double.parse(litrosDieselController.text),
        valorLitroDiesel: double.parse(valorLitroDieselController.text),
        litrosArla: double.parse(litrosArlaController.text),
        valorLitroArla: double.parse(valorLitroArlaController.text),
        pedagios: double.parse(pedagiosController.text),
        alimentacao: double.parse(alimentacaoController.text),
        hospedagem: double.parse(hospedagemController.text),
        outrasDespesas: double.parse(outrasDespesasController.text),
        valorFrete: double.parse(valorFreteController.text),
      );

      await viagemRepository.inserir(viagem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Viagem salva com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar viagem: $e')),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _selecionarData(BuildContext context, bool isSaida) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isSaida ? dataSaida : (dataChegada ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isSaida) {
          dataSaida = pickedDate;
        } else {
          dataChegada = pickedDate;
        }
      });
    }
  }

  @override
  void dispose() {
    origemController.dispose();
    destinoController.dispose();
    kmInicialController.dispose();
    kmFinalController.dispose();
    litrosDieselController.dispose();
    valorLitroDieselController.dispose();
    litrosArlaController.dispose();
    valorLitroArlaController.dispose();
    pedagiosController.dispose();
    alimentacaoController.dispose();
    hospedagemController.dispose();
    outrasDespesasController.dispose();
    valorFreteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && clientes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nova Viagem')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Viagem'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // === SEÇÃO: SELEÇÕES ===
            const Text(
              'Informações Básicas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Cliente>(
              value: clienteSelecionado,
              hint: const Text('Selecione um cliente'),
              items: clientes
                  .map((cliente) => DropdownMenuItem(
                        value: cliente,
                        child: Text(cliente.nome),
                      ))
                  .toList(),
              onChanged: (cliente) =>
                  setState(() => clienteSelecionado = cliente),
              validator: (value) => value == null ? 'Selecione um cliente' : null,
              decoration: const InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Motorista>(
              value: motoristaSelecionado,
              hint: const Text('Selecione um motorista'),
              items: motoristas
                  .map((motorista) => DropdownMenuItem(
                        value: motorista,
                        child: Text(motorista.nome),
                      ))
                  .toList(),
              onChanged: (motorista) =>
                  setState(() => motoristaSelecionado = motorista),
              validator: (value) =>
                  value == null ? 'Selecione um motorista' : null,
              decoration: const InputDecoration(
                labelText: 'Motorista',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Caminhao>(
              value: caminhaoSelecionado,
              hint: const Text('Selecione um caminhão'),
              items: caminhoes
                  .map((caminhao) => DropdownMenuItem(
                        value: caminhao,
                        child: Text(caminhao.placa),
                      ))
                  .toList(),
              onChanged: (caminhao) =>
                  setState(() => caminhaoSelecionado = caminhao),
              validator: (value) =>
                  value == null ? 'Selecione um caminhão' : null,
              decoration: const InputDecoration(
                labelText: 'Caminhão',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // === SEÇÃO: ROTA ===
            const Text(
              'Rota',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: origemController,
              decoration: const InputDecoration(
                labelText: 'Origem',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Informe a origem' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: destinoController,
              decoration: const InputDecoration(
                labelText: 'Destino',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Informe o destino' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Data de Saída'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(dataSaida)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selecionarData(context, true),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Data de Chegada (Opcional)'),
              subtitle: dataChegada != null
                  ? Text(DateFormat('dd/MM/yyyy').format(dataChegada!))
                  : const Text('Não informada'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selecionarData(context, false),
            ),
            const SizedBox(height: 24),

            // === SEÇÃO: QUILOMETRAGEM ===
            const Text(
              'Quilometragem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: kmInicialController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'KM Inicial',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Informe o KM inicial' : null,
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: kmFinalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'KM Final',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Informe o KM final' : null,
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('KM Rodados'),
                trailing: Text(
                  distancia.toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // === SEÇÃO: COMBUSTÍVEIS ===
            const Text(
              'Combustíveis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: litrosDieselController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Litros Diesel',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Informe litros de diesel' : null,
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: valorLitroDieselController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor do Litro Diesel (R\$)',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Informe o valor do litro' : null,
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Custo Diesel'),
                trailing: Text(
                  'R\$ ${custoDiesel.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: litrosArlaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Litros Arla 32',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: valorLitroArlaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor do Litro Arla (R\$)',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Custo Arla'),
                trailing: Text(
                  'R\$ ${custoArla.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Consumo Médio'),
                trailing: Text(
                  '${mediaKmLitro.toStringAsFixed(2)} km/L',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // === SEÇÃO: DESPESAS ===
            const Text(
              'Despesas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: pedagiosController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Pedágios (R\$)',
                border: OutlineInputBorder(),
              ),
              initialValue: '0',
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: alimentacaoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Alimentação (R\$)',
                border: OutlineInputBorder(),
              ),
              initialValue: '0',
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: hospedagemController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Hospedagem (R\$)',
                border: OutlineInputBorder(),
              ),
              initialValue: '0',
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: outrasDespesasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Outras Despesas (R\$)',
                border: OutlineInputBorder(),
              ),
              initialValue: '0',
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 24),

            // === SEÇÃO: FRETE ===
            const Text(
              'Frete',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: valorFreteController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor do Frete (R\$)',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Informe o valor do frete' : null,
              onChanged: (_) => calcular(),
            ),
            const SizedBox(height: 24),

            // === SEÇÃO: RESUMO ===
            const Text(
              'Resumo Financeiro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Custo Total'),
                      trailing: Text(
                        'R\$ ${custoTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Custo por KM'),
                      trailing: Text(
                        'R\$ ${custoPorKm.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Lucro Líquido'),
                      trailing: Text(
                        'R\$ ${lucroLiquido.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: lucroLiquido >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Margem de Lucro'),
                      trailing: Text(
                        '${margemLucro.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: margemLucro >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // === BOTÕES ===
            ElevatedButton(
              onPressed: isLoading ? null : salvarViagem,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Salvar Viagem'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
