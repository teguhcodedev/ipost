<?php

namespace App\Exports;

use App\CustomerPreview;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Concerns\Exportable;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Excel;

use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Events\AfterSheet;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Borders;

class CustomersExport implements FromCollection, Responsable, WithMapping, WithHeadings, ShouldAutoSize, WithEvents
{
    use Exportable;
    /**
     * It's required to define the fileName within
     * the export class when making use of Responsable.
     */
    private $fileName = 'Customers.xlsx';

    /**
     * Optional Writer Type
     */
    private $writerType = Excel::XLSX;

    /**
     * @return \Illuminate\Support\Collection
     */
    public function collection()
    {

        $CustomerPreview = CustomerPreview::all();
        return $CustomerPreview;
    }

    public function headings(): array
    {
        //$campaign = DB::select('SELECT nama_campaign FROM temp_preview_customers LIMIT 1');

        return [
            'Status', 'Id', 'Name', 'Mphone', 'Bphone', 'Hphone', 'Sex', 'Agenow', 'Zipcode', 'Jenis Kartu'
        ];
    }

    public function registerEvents(): array
    {
        return [
            AfterSheet::class    => function (AfterSheet $event) {

                $row = CustomerPreview::all()->count() + 1;
                $cellRange = 'A1:J' . $row; // All headers
                $event->sheet->getDelegate()->getStyle($cellRange)->getFont()->setName('Calibri');
                $event->sheet->getDelegate()->getStyle($cellRange)->getFont()->setSize(11);
                $event->sheet->getDelegate()->getStyle('A1:J1')->getFont()->setBold(True);

                $styleArray = [
                    'borders' => [
                        // 'outline' => [
                        //     'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THICK,
                        // ],
                        'allBorders' => [
                            'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN,
                        ],
                    ],
                    'alignment' => [
                        'horizontal' => \PhpOffice\PhpSpreadsheet\Style\Alignment::HORIZONTAL_CENTER,
                    ],
                ];

                $event->sheet->getDelegate()->getStyle($cellRange)->applyFromArray($styleArray);
            },
        ];
    }
    public function map($CustomerPreview): array
    {
        return [
            $CustomerPreview->status_upload,
            $CustomerPreview->cust_id,
            $CustomerPreview->name,
            $CustomerPreview->mphone,
            $CustomerPreview->bphone,
            $CustomerPreview->hphone,
            $CustomerPreview->sex,
            $CustomerPreview->agenow,
            $CustomerPreview->zipcode,
            $CustomerPreview->jenis_kartu,
        ];
    }
}
